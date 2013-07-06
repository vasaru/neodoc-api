/**
 * Generic Editable Grid for managing options
 */
Ext.define('NeoDoc.view.option.List', {
    extend: 'Ext.grid.Panel',
    alias: 'widget.option.list',
    requires: [
        'Ext.grid.plugin.RowEditing',
        'Ext.toolbar.Paging',
        'Ext.grid.column.Boolean',
        'Ext.grid.column.Date',
        'Ext.form.field.Date',
        'NeoDoc.ux.form.field.RemoteComboBox'
    ],
    extraColumns: null,
    initComponent: function() {
        var me = this,
            columns = [
    		{
    			text: 'Last Updated',
    			dataIndex: 'updated_at',
                xtype: 'datecolumn',
                dateFormat: 'Y-m-d',
                flex: 0.5
    		},
    		{
    			text: 'Last Updated by',
    			dataIndex: 'updated_by',
                flex: 0.5
    		},
            {
                xtype: 'booleancolumn',
                text: 'Active',
                dataIndex: 'status',
                trueText: 'Yes',
                falseText: 'No',
                flext: 0.5
            }
        ];

        if( !Ext.isEmpty( me.extraColumns ) ) {
            console.log("Columns:" + columns);
            console.log("ExtraColumns:" + me.extraColumns );
            columns = me.extraColumns.concat( columns );
            console.log(columns);
        }

        Ext.applyIf(me,{
            selType: 'rowmodel',
            plugins: [
                {
                    ptype: 'rowediting',
                    clicksToEdit: 2
                }
            ],
            columns: {
                defaults: {},
                items: columns
            },
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    ui: 'footer',
                    items: [
                        {
                            xtype: 'button',
                            itemId: 'add',
                            iconCls: 'icon_add',
                            text: 'Add Item'
                        }
                    ]
                },
                {
                    xtype: 'pagingtoolbar',
                    ui: 'footer',
                    defaultButtonUI: 'default',
                    dock: 'bottom',
                    displayInfo: true,
                    store: me.getStore()
                }
            ]
        });
        me.callParent( arguments );
    } 
});
