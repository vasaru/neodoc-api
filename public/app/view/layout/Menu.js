/**
 * Main top-level navigation for application
 */
Ext.define('NeoDoc.view.layout.Menu', {
    extend: 'Ext.menu.Menu',
    alias: 'widget.layout.menu',
    floating: false,
    initComponent: function(){
        var me = this;
        Ext.applyIf(me,{
            items: [
                {
                    text: 'Options',
                    iconCls: 'icon_gear',
//                    hidden: !CarTracker.LoggedInUser.inRole( 1 ),
                    menu: [
                        {
                            text: 'Operating Systems',
                            itemId: 'option/operatingsystem',
                            iconCls: 'icon_make'
                        },
                        {
                            text: 'Operating Systems Versions',
                            itemId: 'option/osversion',
                            iconCls: 'icon_make'
                        },
                        {
                            text: 'Device Types',
                            itemId: 'option/devicetype',
                            iconCls: 'icon_model'
                        },
                        {
                            text: 'Users',
                            itemId: 'option/users',
                            iconCls: 'icon_users'
                        },
                        {
                            text: 'Admin Roles',
                            itemId: 'option/userrole',
                            iconCls: 'icon_role'
                        }
                    ]
                },
                {
                    xtype: 'menuseparator'
                },
                {
                    text: 'Locations',
                    itemId: 'location',
                    iconCls: 'icon_location'
//                    hidden: !CarTracker.LoggedInUser.inRole( 1 )
                },
                {
                    xtype: 'menuseparator'
                },
                {
                    text: 'Customers',
                    itemId: 'customers',
                    iconCls: 'icon_customers'
                },
                {
                    xtype: 'menuseparator'
                },
                {
                    text: 'Logout',
                    itemId: 'logout',
                    iconCls: 'icon_login'
                }
            ]
        });
        me.callParent( arguments );
    } 
});