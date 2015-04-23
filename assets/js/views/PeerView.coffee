'use strict'

class Webrtc.Views.PeerView extends Backbone.View
  
  template: JST['templates/peerview']
  
  initialize: ->
    @model = new Webrtc.Models.Peer() unless @model
    this.listenTo(this.model, 'change', this.render)
    @render()
    return
  
  render: ->
    #$('body').append(@template())
    
    this.$el.html(this.template())
    
    _.each(@model.servers.views, (view) =>
      this.$el.append(view.render().el)
    )
    _.each(@model.peers.views, (view) =>
      this.$el.append(view.render().el)
    )
    # this.$el.append
    # .render()
    # @models.peers.render()
    return this
