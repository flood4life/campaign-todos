module TransactionHelper
  def schema_validate(schema, input)
    result = schema.(input)
    if result.success?
      Success(result.output)
    else
      Failure(result.messages)
    end
  end
end