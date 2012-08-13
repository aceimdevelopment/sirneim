# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
#infleciones en espanol
ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural( /$/, 'es')
  inflect.plural(/z$/i, 'ces')
  inflect.plural(/([aeiou])$/i, '\1s')

  inflect.singular(/s$/i, '')
  inflect.singular(/es$/i, '')
  inflect.singular(/ces$/i, 'z')
  inflect.singular(/([tj])es$/i, '\1e')
end