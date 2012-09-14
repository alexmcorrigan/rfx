class Currency

    attr_reader :code, :field_name

    def initialize field_name, code
        @code = code
        @field_name = field_name
    end

    def validate currency_code_validator
        currency_code_validator.validate self
    end

end
