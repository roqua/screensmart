# A stateless response to a given set of questions in one domain.
# Initializing is done by setting answer_values as a hash, for example:
#   r = Response.new(answer_values: { 'EL02' => 1 })
#
# After this, all attributes can be read in an OOP way, for example:
#   r.questions # All questions, including the next (unanswered) one
#   # => [#<Question:0x007faadb3459a8 @id="EL02", @answer_value: 1>,
#         #<Question:0x007faadb2d49d8 @id="EL03">]
class DomainResponse < BaseModel
  # @see https://github.com/roqua/screensmart-r/blob/master/inst/extdata/estimate_interpretations_quartiles.csv
  QUARTILE_MAPPINGS = {
    'Laag niveau (++)'            => 'Q1', # Psychopathologie
    'Matig niveau (+)'            => 'Q2',
    'Verhoogd niveau (-)'         => 'Q3',
    'Sterk verhoogd niveau (--)'  => 'Q4',
    'Laag niveau (--)'            => 'Q1', # Positieve constructen
    'Matig niveau (-)'            => 'Q2',
    'Hoog niveau (+)'             => 'Q3',
    'Zeer hoog niveau (++)'       => 'Q4'
  }.freeze

  DOMAIN_SIGNS = {
    'POS-PQ'    => 'neg',
    'NEG-PQ'    => 'neg',
    'ANX-PRO'   => 'neg',
    'DEP-PRO'   => 'neg',
    'SAT-PRO'   => 'pos',
    'FRS-PRO'   => 'pos',
    'EMO-PRO'   => 'pos',
    'DIS-4DKL'  => 'neg'
  }.freeze

  NORM_POPULATION_LABELS = {
    'pos' => 'Algemene bevolking',
    'neg' => 'Cliënten eerste lijn GGZ'
  }.freeze

  attr_accessor :domain_id, :response

  # accessors for attributes defined by R package
  %i(estimate variance warning).each do |r_attribute|
    define_method r_attribute do
      ensure_valid do
        RPackage.data_for(answer_values, [domain_id])[r_attribute]
      end
    end
  end

  def answer_values
    # Filter all of the response's answer values by those belonging to this domain
    response.answer_values.select do |id, _|
      RPackage.question_by_id(id)['domain_id'] == domain_id
    end
  end

  def domain_sign
    DOMAIN_SIGNS[domain_id]
  end

  def norm_population_label
    NORM_POPULATION_LABELS[domain_sign]
  end

  def quartile
    QUARTILE_MAPPINGS[estimate_interpretation]
  end
end
