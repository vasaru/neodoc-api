/**
 * Model representing a Position object
 */
Ext.define('NeoDoc.model.option.OperatingSystem', {
   extend: 'NeoDoc.model.option.Base',
   idProperty: 'id',
   fields: [
       // id field
       {
           name: 'id',
           type: 'int',
           useNull : true
       },
       {
            name: 'name',
            type: 'string'
        },
        {
            name: 'vendor',
            type: 'string'
        },
        {
            name: 'license',
            type: 'string'
        },
        {
            name: 'url',
            type: 'string'
        },
        {
            name: 'iconCls',
            type: 'string'
        },
        {
            name: 'status',
            type: 'string'
        },
        {
            name: 'cls',
            type: 'string'
        },
   ] 
});