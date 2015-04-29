'use strict'

class App.IndexView extends Backbone.View
  
  template: JST['templates/index']
  
  tagName: 'div'
  
  #className: 'view large-6 columns'
  
  user: null
  
  view: null
  
  events:
    'click .create-user': 'createUser'
  #  'click .button.edit': 'openEditDialog'
  #  'click .button.delete': 'destroy'
  
  #peers: null
  
  initialize: (group, username) ->
    @group = group
    @username = username
    @oldUsername = localStorage.getItem('username')
    @createUser() if @username?
    return
  
  
  render: ->
    unless @view
      @$el.html( @template(group: @group, oldUsername: @oldUsername ) )
    else
      @$el.html('')
      @$el.append(@view.render().el)
    return this

  createUser: =>
    #console.log this
    unless typeof(@username) is 'string'
      @username =  @$('input#username').val()#.toString()
    #console.log username
    #console.log  @$('input#username').val()
    @user = new App.User(@username)
    @view = new App.UserView(model:@user)
    @render()
    Backbone.history.navigate("#{@group}/#{@username}")
  #discover: ->
  #  @model.discover()
