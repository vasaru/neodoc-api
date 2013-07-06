/*
    This file is generated and updated by Sencha Cmd. You can edit this file as
    needed for your application, but these edits will have to be merged by
    Sencha Cmd when upgrading.
*/

// DO NOT DELETE - this directive is required for Sencha Cmd packages to work.
//@require @packageOverrides

Ext.util.Format.yesNo = function( v ) {
    return v ? 'Yes' : 'No';
};

Ext.application({
    name: 'NeoDoc',

    views: [
    	'Viewport'
    ],
    controllers: [
    	'App',
    	'Options'
//    	'Locations',
//    	'Customers',
//    	'Security'
    ],
    requires: [
    	'Ext.util.History',
    	'Ext.util.Point',
    	'NeoDoc.domain.Proxy'
    ],
    autoCreateViewport: true,

    launch: function( args ) {
        // "this" = Ext.app.Application
        var me = this;
        // init Ext.util.History on app launch; if there is a hash in the url,
        // our controller will load the appropriate content
        Ext.util.History.init(function(){
            var hash = document.location.hash;
            me.getAppController().fireEvent( 'tokenchange', hash.replace( '#', '' ) );
        })
        // add change handler for Ext.util.History; when a change in the token
        // occurs, this will fire our controller's event to load the appropriate content
        Ext.util.History.on( 'change', function( token ){
            me.getAppController().fireEvent( 'tokenchange', token );
        });     
    }    

});
