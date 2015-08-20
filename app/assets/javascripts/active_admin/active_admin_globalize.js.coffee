class ActiveAdminGlobalize

  translations: (container=document) ->

    $container = $(container)

    $(".activeadmin-translations > ul", $container).each ->
      $dom = $(this)
      if !$dom.data("ready")
        $dom.data("ready", true)
        $tabs = $("li > a", this)
        $contents = $(this).siblings("fieldset")

        $tabs.click ->
          $tab = $(this)
          $tabs.not($tab).removeClass("active")
          $tab.addClass("active")
          $contents.hide()
          $contents.filter($tab.attr("href")).show()
          false

        $tabs.eq(0).click()

        $tabs.each ->
          $tab = $(@)
          $content = $contents.filter($tab.attr("href"))
          containsErrors = $content.find(".input.error").length > 0
          $tab.toggleClass("error", containsErrors)


$ ->
  globalizer = new ActiveAdminGlobalize
  globalizer.translations()

  $(document).on 'translations:refresh', =>
    globalizer.translations()

  # this is to handle elements created with has_many
  $(document).on 'has_many_add:after', (event, fieldset, parent) ->
    setTimeout =>
      globalizer.translations(fieldset)
    , 50
