/**
 * Base {@link Ext.data.Model} from which all other models will extend
 */
Ext.define('NeoDoc.model.Base', {
   extend: 'Ext.data.Model',

   fields: [
       // non-relational properties
        {
            name: 'updated_by',
            type: 'string'
        },
        {
            name: 'created_at',
            type: 'date',
//            dateFormat: 'Y-m-d'
        },
        {
            name: 'created_by',
            type: 'string'
        },
        {
            name: 'updated_at',
            type: 'date',
            dateFormat: 'Y-m-d'
        }
   ] 
});