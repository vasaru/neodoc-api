Ext.define('NeoDoc.view.layout.South', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.layout.south',
    region: 'south',
    bodyPadding: 5,
    requires: [
        'Ext.toolbar.TextItem',
        'Ext.toolbar.Spacer'
    ],
    cls: 'footer',                  
    initComponent: function(){
        var me = this;
        Ext.applyIf(me,{
            items: [
                {
                    xtype: 'toolbar',
                    height: 37,
                    items: [
                        {
                            xtype: 'tbfill'
                        },
                        {
                            xtype: 'tbseparator'
                        },
                        {
                            xtype: 'tbtext',
                            itemId: 'loggedintext',
                            text: 'My Text'
                        },
                        {
                            xtype: 'tbspacer',
                            width: 50
                        },
                        {
                            xtype: 'tbseparator'
                        },
                        {
                            xtype: 'button',
                            iconCls: 'logout_user',
                            text: 'Logout'
                        }
                    ]
                }
            ]
        });
        me.callParent( arguments );
    } 
});