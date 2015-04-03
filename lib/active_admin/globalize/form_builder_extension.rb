module ActiveAdmin
  module Globalize
    module FormBuilderExtension
      extend ActiveSupport::Concern

      def translated_inputs(name = "Translations", options = {})
        options.symbolize_keys!

        switch_locale = options.fetch(:switch_locale, false)

        auto_sort = options.fetch(:auto_sort, true)

        html = template.content_tag(:div, class: "activeadmin-translations") do

          template.content_tag(:ul, class: "available-locales") do

            I18n.available_locales.sort.map do |locale|
              template.content_tag(:li) do
                I18n.with_locale(switch_locale ? locale : I18n.locale) do
                  template.content_tag(:a, I18n.t(:"active_admin.globalize.language.#{locale}"), href:".locale-#{locale}")
                end
              end
            end.join.html_safe

          end <<

          I18n.available_locales.sort.map do |locale|
            translation = object.translations.find { |t| t.locale.to_s == locale.to_s }
            translation ||= object.translations.build(locale: locale)

            fields = proc do |form|
              I18n.with_locale(switch_locale ? locale : I18n.locale) do
                id_field = form.input :id, :as => :hidden
                locale_field = form.input :locale, :as => :hidden

                [:id, :locale].tap do |fields_for_translation_form|
                  translated_fields = form.options[:parent_builder].object.class.translated_attribute_names
                  fields_for_translation_form << form.inputs(*translated_fields)
                end
              end
            end

            inputs_for_nested_attributes(
              for: [:translations, translation ],
              class: "inputs locale locale-#{translation.locale}",
              &fields
            )
          end.join.html_safe
        end

        if template.output_buffer
          return template.concat html
        else
          return html
        end
      end

      module ClassMethods
      end
    end
  end
end
