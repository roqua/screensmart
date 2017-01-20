# Value object that represents all test outcomes for a given domain
class DomainResult < BaseModel
  # @see https://github.com/roqua/screensmart-r/blob/master/inst/extdata/estimate_interpretations_quartiles.csv
  QUARTILE_MAPPINGS = {
    'Laag niveau (++)'            => 'Q1', # Psychopathology
    'Matig niveau (+)'            => 'Q2',
    'Verhoogd niveau (-)'         => 'Q3',
    'Sterk verhoogd niveau (--)'  => 'Q4',
    'Laag niveau (--)'            => 'Q1', # Positive constructs
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
  %i(estimate estimate_interpretation variance warning).each do |r_attribute|
    define_method r_attribute do
      ensure_valid do
        data_from_r[r_attribute]
      end
    end
  end

  def data_from_r
    response.data_from_r[:domain_results][domain_id]
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
