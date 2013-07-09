/**
 * Main controller for all top-level application functionality
 */
Ext.define('NeoDoc.controller.App', {
    extend: 'NeoDoc.controller.Base',
    views: [
        'layout.Menu',
        'layout.Center',
        'layout.Landing'
    ],
    refs: [
        {
            ref: 'Menu',
            selector: '[xtype=layout.menu]'
        },
        {
            ref: 'CenterRegion',
            selector: '[xtype=layout.center]'
        }
    ],
    init: function() {
        this.listen({
            controller: {
                '#App': {
                    tokenchange: this.dispatch
                }
            },
            component: {
                'menu[xtype=layout.menu] menuitem': {
                    click: this.addHistory
                } 
            },
            global: {},
            store: {},
            proxy: {
                '#baserest': {
                    requestcomplete: this.handleRESTResponse
                }
            } 
        });
    },
    /**
     * Add history token to Ext.util.History
     * @param {Ext.menu.Item} item
     * @param {Object} e
     * @param {Object} opts
     */
    addHistory: function( item, e, opts ) {
        var me = this,
            token = item.itemId;
        if( !Ext.isEmpty( token ) ) {
            Ext.util.History.add( token );
            me.fireEvent( 'tokenchange', token )
        }
    },
    /**
     * Handles token change and directs creation of content in center region
     * @param {String} token
     */
    dispatch: function( token ) {
        var me = this,
            config;
        // switch on token to determine which content to create
        switch( token ) {
            case 'option/operatingsystem':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Operating systems',
                    iconCls: 'icon_make',
                    store: Ext.create( 'NeoDoc.store.option.OperatingSystem', {
                        pageSize: 30
                    }),
                    extraColumns: [
                        {
                        text: 'Name',
                        dataIndex: 'name',
                        editor: {
                            xtype: 'textfield',
                            allowBlank: false
                        },
                        flex: 2
                    },
                    {
                        xtype: 'gridcolumn',
                        text: 'URL',
                        dataIndex: 'url',
                        editor: {
                            xtype: 'textfield',
                            allowBlank: false
                        },
                        flex: 1
                    }
                    ]

                };
                break;
            case 'option/osversion':
                config = {
                    xtype: 'option.list',
                    title: 'Manage OS Versions',
                    iconCls: 'icon_model',
                    store: Ext.create( 'NeoDoc.store.option.OsVersion', {
                        pageSize: 30
                    }),
                    extraColumns: [
                            {
                            text: 'Operating System',
                            dataIndex: 'osname',
                            renderer: function( value, metaData, record, rowIndex, colIndex, store, view ) {
                                console.log(record);
                                return record.get( '_osname' )
                            },
		    	    flex: 1.5,
                            editor: {
                                xtype: 'ux.form.field.remotecombobox',
                                displayField: 'name',
                                valueField: 'osid',
                                store: {
                                    type: 'option.operatingsystem'
                                },
                                allowBlank: false
                            }
                        },
                        {
                            text: 'Name',
                            dataIndex: 'name',
                            editor: {
                                xtype: 'textfield',
                                allowBlank: false
                            },
                            flex: 2
                        },
                        {
                            text: 'Major Version',
                            dataIndex: 'major',
                            editor: {
                                xtype: 'textfield',
                                allowBlank: true
                            },
                            flex: 1
                        },
                        {
                            text: 'Minor Version',
                            dataIndex: 'minor',
                            editor: {
                                xtype: 'textfield',
                                allowBlank: true
                            },
                            flex: 1
                        },
                        {
                            text: 'Build Number',
                            dataIndex: 'build',
                            editor: {
                                xtype: 'textfield',
                                allowBlank: true
                            },
                            flex: 1
                        },
                        {
                            text: 'Release Date',
                            xtype: 'datecolumn',
                            dataIndex: 'releasedate',
                            editor: {
                                xtype: 'datefield',

                                allowBlank: true
                            },
                            flex: 1.2
                        }


                    ]
                };
                break;
            case 'option/category':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Car Categories',
                    iconCls: 'icon_category',
                    store: Ext.create( 'NeoDoc.store.option.Categories', {
                        pageSize: 30
                    })
                };
                break;
            case 'option/color':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Car Colors',
                    iconCls: 'icon_color',
                    store: Ext.create( 'NeoDoc.store.option.Colors', {
                        pageSize: 30
                    })
                };
                break;
            case 'option/feature':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Car Features',
                    iconCls: 'icon_feature',
                    store: Ext.create( 'NeoDoc.store.option.Features', {
                        pageSize: 30
                    })
                };
                break;
            case 'option/position':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Staff Positions',
                    iconCls: 'icon_position',
                    store: Ext.create( 'NeoDoc.store.option.Positions', {
                        pageSize: 30
                    })
                };
                break;
            case 'option/status':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Statuses',
                    iconCls: 'icon_status',
                    store: Ext.create( 'NeoDoc.store.option.Statuses', {
                        pageSize: 30
                    })
                };
                break;
            case 'option/drivetrain':
                config = {
                    xtype: 'option.list',
                    title: 'Manage Drive Trains',
                    iconCls: 'icon_drivetrain',
                    store: Ext.create( 'NeoDoc.store.option.DriveTrains', {
                        pageSize: 30
                    })
                };
                break;
            case 'staff':
                config = {
                    xtype: 'staff.list'
                };
                break;
            case 'inventory':
                config = {
                    xtype: 'car.list'
                };
                break;
            default: 
                config = {
                    xtype: 'layout.landing'
                };
                break;
        }
        me.updateCenterRegion( config );
    },
    /**
     * Updates center region of app with passed configuration
     * @param {Object} config
     * @private
     */
    updateCenterRegion: function( config ) {
        var me = this,
            center = me.getCenterRegion();
        
        // remove all existing content
        center.removeAll( true );
        // add new content
        center.add( config );
    },
    /**
     * After a REST response is completed, this method will marshall the response data and inform other methods with relevant data
     * @param {Object} request
     * @param {Boolean} success The actual success of the AJAX request. For success of {@link Ext.data.Operation}, see success property of request.operation
     */
    handleRESTResponse: function( request, success ) {
        var me = this,
            rawData = request.proxy.reader.rawData;
        // in all cases, let's hide the body mask
        Ext.getBody().unmask();
        // if proxy success
        if( success ) {
            // if operation success
            if( request.operation.wasSuccessful() ) {

            }
            // if operation failure
            else {
                // switch on operation failure type
                switch( rawData.type ) {
                    case 'validation':
                        me.showValidationMessage( rawData.data, rawData.success, rawData.message, rawData.type );
                        break;
                }
            }
        }
        // otherwise, major failure...
        else {

        }
    },
    /**
     * Displays errors from JSON response and tries to mark offending fields as invalid
     * @param {NeoDoc.proxy.Rest} proxy
     * @param {Array} data
     * @param {Boolean} success
     * @param {String} message
     * @param {String} type
     */
    showValidationMessage: function( data, success, message, type ) {
        var me = this,
            errorString = '<ul>';
        // looping over the errors
        for( var i in data ) {
            var error = data[ i ];
            errorString += '<li>' + error.message + '</li>';
            // match form field with same field name
            var fieldMatch = Ext.ComponentQuery.query( 'field[name=' + error.field + ']' );
            // match?
            if( fieldMatch.length ) {
                // add extra validaiton message to the offending field
                fieldMatch[ 0 ].markInvalid( error.message );
            }
        }
        errorString += '</ul>';
        // display error messages in modal alert
        Ext.Msg.alert( message, errorString );
    }
});
