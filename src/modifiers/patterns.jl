module Patterns

    using ReusePatterns

    using ...AbstractSuperType
    using ..Modifiers

    export Pattern
    export GeneralPattern, DiscontinuousPattern, NormalDependentPattern

    export AGATE, BOXED, BOZO
    export CHECKER


    @quasiabstract struct Pattern <: AbstractModifier
        tag::Symbol
    end

    @quasiabstract struct GeneralPattern <: Pattern end
    @quasiabstract struct DiscontinuousPattern <: Pattern end 
    @quasiabstract struct NormalDependentPattern <: Pattern end

    AbstractSuperType.construct_povray(pattern::Pattern) = "$(pattern.tag)"

    # General Patterns 
    const AGATE = GeneralPattern(:agate)
    const BOXED = GeneralPattern(:boxed)
    const BOZO = GeneralPattern(:bozo)

    # Discontinuous Patterns
    const CHECKER = DiscontinuousPattern(:checker)
end

module PatternModifiers

    using ReusePatterns

    using ...AbstractSuperType
    using ..Modifiers

end