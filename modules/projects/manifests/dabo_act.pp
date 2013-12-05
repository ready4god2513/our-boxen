class projects::dabo_act {
  include phantomjs

  boxen::project { 'dabo_act':
    redis         => true,
    postgresql    => true,
    ruby          => '1.9.3-p484',
    source        => 'dabohealth/dabo_act'
  }
}
