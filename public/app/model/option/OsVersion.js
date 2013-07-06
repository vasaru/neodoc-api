/**
 * Model representing a Position object
 */
Ext.define('NeoDoc.model.option.OsVersion', {
   extend: 'NeoDoc.model.option.Base',
   idProperty: 'osvid',
   fields: [
       // id field
       {
           name: 'osvid',
           type: 'int',
           useNull : true
       },
       {
           name: 'osid',
           type: 'int',
           useNull : true
       },
       {
            name: 'name',
            type: 'string'
        },
        {
            name: 'major',
            type: 'string'
        },
        {
            name: 'minor',
            type: 'string'
        },
        {
            name: 'build',
            type: 'string'
        },
        {
            name: 'patch',
            type: 'string'
        },
        {
            name: 'releasedate',
            type: 'date'
        },
        {
            name: 'isourl',
            type: 'string'
        },
        {
            name: 'status',
            type: 'string'
        },
        {
            name: 'downloadurl',
            type: 'string'
        },
        {
            name: 'description',
            type: 'string'
        },


        {
            name: 'cls',
            type: 'string'
        },
   ] 
});