'use strict'
## ContentView
class App.ContentView extends Backbone.View
  
  template: JST['templates/content']
  
  tagName: 'div'
  
  id: null
  
  className: 'content view'
  
  events:
    'click .edit-content.button'  : 'edit'
    'blur  .edit-area textarea'  : 'blur'
  
  initialize: ->
    #@listenTo @model, 'change', @render
    return
  
  render: =>
    @$el.html(this.template(content:@model.get('content')))
    @$('.edit-area')
    this.delegateEvents()
    return this
  
  edit: =>
    this.$('.edit-area').removeClass('inactive')
    this.$('.edit-area').html(
      "<textarea rows='20'>#{@model.get('content')}</textarea>"
    )
  
  blur: =>
    newContent = this.$('.edit-area textarea').val()
    @model.set('content', newContent)
    @model.save()
    @render()
