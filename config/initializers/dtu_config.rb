Rails.application.config.pubmed = {
    :url    => "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?id=%<id>s&db=pubmed&retmode=xml&tool=%<tool>s&email=%<email>s",
    :tool   => '',
    :email  => '',
    :dtu_id => ''
}
