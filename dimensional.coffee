define ['cs!conversions'], (conversions) ->
    canonical_units = conversions.canonical_units
    unit_conversions = conversions.unit_conversions

    # Makes a reverse index on the conversion table
    unit_definitions = {}
    for dimension, units of unit_conversions
        for unit, value of units
            unit_definitions[unit] = 
                dimension:dimension
                value:value

    make_dimensions = ->
        ###* Creates a fresh dimensions object, with zeroes for the exponents on each dimension type. ###
        dimensions = {}
        for key of unit_conversions
            dimensions[key] = 0
        return dimensions

    tally_dimensions = (source, dimensions, direction=+1) ->
        ###* Helper for the numerator or denomonator.
        Counts the dimensions by type and computes the conversion factor.  ###

        factor = 1
        for component in source.split(' ')
            [unit, exponent] = component.split('^')
            exponent ||= 1
            unit_definition = unit_definitions[unit]
            dimensions[unit_definition.dimension] += exponent * direction
            factor *= unit_definition.value
        factor

    parse_units = (str) ->
        ###* Examples: s, m/s, s^2, m/s^2, ft^2, m s
        Returns a conversion factor and the dimensions found. ###
        str ||= ''
        dimensions = make_dimensions()
        factor = 1
        [numerator, denomonator] = str.split('/')
        factor *= tally_dimensions numerator, dimensions, +1 if numerator
        factor /= tally_dimensions denomonator, dimensions, -1 if denomonator
        [factor, dimensions]

    show_single_unit = (dimension, exponent) ->
        ###* Shows the canonical unit for a given dimension, with an exponent ###
        string = canonical_units[dimension]
        if exponent isnt 1
            string += "^#{exponent}"
        string

    show_units = (dimensions) ->
        ###* Shows a unit with all its dimensions and exponents ###
        numerator = []
        denomonator = []

        for key, value of dimensions
            exponent = Math.abs value
            numerator.push show_single_unit key, exponent if value > 0
            denomonator.push show_single_unit key, exponent if value < 0

        string = numerator.join(' ')
        if denomonator.length
            string += "/#{denomonator.join(' ')}"
        string

    cast_to_unit = (input) ->
        if not isNaN input
            input = new Unit(input)
        input
    
    class Unit
        ###* Represents a value with units.  You can do math with it. ###

        constructor: (value, @units, @canonical_value, @dimensions) ->
            ###* We start by converting your units to the canonical ones, so math is easier.
            If you provide the canonical units and dimensions, we will use those instead,
            but they are mostly for internal use. ###
            if not @canonical_value and not @dimensions
                [factor, @dimensions] = parse_units @units
                @canonical_value = value * factor

        show: ->
            ###* Shows your value with canonical units.
            TODO: convert to the original units if they are available ###
            "#{@canonical_value}#{show_units(@dimensions)}"

        add: (unit) ->
            ###* Adds a value to another value.  Both must be units with the same dimensions ###
            unit = cast_to_unit(unit)
            if JSON.stringify(unit.dimensions) isnt JSON.stringify(@dimensions)
                throw "Can't add #{show_units(unit.dimensions)} to #{show_units(@dimensions)}."
            else
                new Unit null, @units, @canonical_value + unit.canonical_value, @dimensions

        subtract: (unit) ->
            ###* Similar to add ###
            unit = cast_to_unit(unit)
            @add(unit.multiply(Unit -1))
                
        reciprocal: ->
            new_dimensions = {}
            for key,value of @dimensions
                new_dimensions[key] = -value
            new Unit null, null, 1/@canonical_value, new_dimensions

        multiply: (unit) ->
            # TODO: figure out new preferred units
            unit = cast_to_unit(unit)
            new_dimensions = {}
            for key of unit_conversions
                new_dimensions[key] = @dimensions[key] + unit.dimensions[key]
            new Unit null, null, @canonical_value * unit.canonical_value, new_dimensions

        divide: (unit) ->
            unit = cast_to_unit(unit)
            @times(unit.reciprocal())

    ###* Aliases with less formal names ###
    Unit::plus = Unit::add
    Unit::minus = Unit::subtract
    Unit::times = Unit::multiply
    Unit::over = Unit::divide
    Unit::flip = Unit::reciprocal
            
    unit_maker = (arguments...) ->
        ### So you don't have to say 'new' all the time ###
        new Unit arguments...

    parse_units:parse_units
    show_units:show_units
    Unit:unit_maker
    unit_class:Unit
