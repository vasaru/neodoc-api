/**
 * Store from which all other option stores will extend
 */
Ext.define('NeoDoc.store.option.Base', {
    extend: 'NeoDoc.store.Base',
    constructor: function( cfg ){
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            storeId: 'option_Base',
            headers: {'Accept':'application/vnd.neodocapi.v1' },
        }, cfg)]);
    },
    sorters: [
        {
            property: 'Name',
            direction: 'ASC'
        }
    ] 
})