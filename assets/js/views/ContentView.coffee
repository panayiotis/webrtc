'use strict'

class App.ContentView extends Backbone.View
  
  template: JST['templates/content']
  
  tagName: 'div'
  
  id: null
  
  className: 'content view'
  
  events:
    'click .edit-area.inactive'        : 'edit'
    'blur .edit-area textarea': 'blur'
  
  initialize: ->
    #@listenTo @model, 'change', @render
    return
  
  render: =>
    @$el.html(this.template(content:@model.get('content')))
    this.delegateEvents()
    return this
  
  edit: =>
    console.log 'edit'
    this.$('.edit-area').removeClass('inactive')
    this.$('.edit-area').html(
      "<textarea rows='10'>#{@model.get('content')}</textarea>"
    )
  
  blur: =>
    newContent = this.$('.edit-area textarea').val()
    console.log newContent
    @model.set('content', newContent)
    @model.save()
    @render()
