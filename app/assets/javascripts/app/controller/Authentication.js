/*
 * File: app/controller/Authentication.js
 *
 * This file was generated by Sencha Architect version 2.2.2.
 * http://www.sencha.com/products/architect/
 *
 * This file requires use of the Ext JS 4.2.x library, under independent license.
 * License of Sencha Architect does not include license for Ext JS 4.2.x. For more
 * details see http://www.sencha.com/license or contact license@sencha.com.
 *
 * This file will be auto-generated each and everytime you save your project.
 *
 * Do NOT hand edit this file.
 */

Ext.define('NeoDoc.controller.Authentication', {
    extend: 'Ext.app.Controller',

    refs: [
        {
            ref: 'viewport',
            selector: 'viewport'
        },
        {
            ref: 'loginWindow',
            selector: 'loginwindow'
        },
        {
            ref: 'loginForm',
            selector: 'loginwindow formpanel'
        }
    ],

    onLoginClick: function(button, e, eOpts) {
        var me = this,
            win = this.getLoginWindow(), 
            form = win.items.items[0].getForm();

        console.log('In onLoginClick');

        var emailField = form.findField('email');
        var passwordField = form.findField('password');
        console.log('email:',emailField);				
        me.authenticateUser({
            user_login : {
                email : emailField.getValue(),
                password : passwordField.getValue()
            }
        }, null); 

    },

    onLogoutClick: function(button, e, eOpts) {
        var me = this;		
        me.getViewport().setLoading('Logging out...');		
        me.destroyAuthentication();
        // this could go to the localStorage. much more awesome 
        // me.showLoginForm();
        // window.location.reload(); 

        // mask for user


        // logout
    },

    init: function(application) {
        var me = this;

        console.log('In init');
        var currentUserBase = localStorage.getItem('neodocUser');
        console.log(localStorage);
        console.log('CurrentUserBase:',currentUserBase);
        if (localStorage.getItem('neodocUser')) {
            console.log('Verifying session');
            Ext.Ajax.request({
                url: '/api/users/verify',
                headers: {'Accept':'application/vnd.neodocapi.v1'},
                method: 'GET',
                params: {
                    auth_token: Ext.decode(currentUserBase).auth_token
                },
                jsonData: {},
                success: function(result, request ) {
                    console.log('Current User is properly logged in');
                    me.currentUser = Ext.decode( currentUserBase ) ;
                    //Verify session
                    console.log("Fireing loggedin event");        
                    // show the protected content
                    me.application.fireEvent('loggedin', me.currentUser);

                },
                failure: function(result, request ) {
                    console.log('Current User is not properly logged in');
                    console.log(result);
                    localStorage.removeItem('neodocUser');
                    currentUserBase=null;
                    window.location.reload();
                }

            });
        }

        console.log('CurrentUserBase:',currentUserBase);
        if( currentUserBase === null){
            var win = Ext.create('NeoDoc.view.LoginWindow', {});
            win.show();
        }




        this.control({
            "loginwindow button[action=login]": {
                click: this.onLoginClick
            },
            "button[action=logout]": {
                click: this.onLogoutClick
            }
        });

        application.on({
            loggedin: {
                fn: this.onLoggedin,
                scope: this
            }
        });
    },

    authenticateUser: function(data, fieldset) {

        var me = this,
            win = this.getLoginWindow(), 
            form = win.items.items[0].getForm();

        // mask while asking the server
        win.setLoading('logging in...');

        Ext.Ajax.request({
            url: '/api/users/sign_in',
            headers: {'Accept':'application/vnd.neodocapi.v1' },
            method: 'POST',
            params: {
            },
            jsonData: data,
            success: function(result, request ) {
                //fieldset.setLoading( false ) ;
                // cleaning the form data
                // var form = fieldset.up('form');
                var passwordField = form.findField('password');
                var emailField = form.findField('email');
                passwordField.setValue('');
                emailField.setValue('');

                var responseText=  result.responseText; 
                var data = Ext.decode(responseText ); 
                var currentUserObject = {
                    'auth_token' : data.auth_token,
                    'email'				: data.email,
                    'role'				: Ext.decode( data.role ),
                    'username'			: data.username,
                    'sign_in_count'		: data.sign_in_count,
                    'current_sign_in_ip': data.current_sign_in_ip
                };

                localStorage.setItem('neodocUser', Ext.encode( currentUserObject ));
                me.currentUser = currentUserObject;
                win.hide();
                // me.getStore('navTreeStore').load();
                me.application.fireEvent('loggedin', me.currentUser);
            },
            failure: function(result, request ) {
                //fieldset.setLoading( false ) ;
                console.log(result);
                win.setLoading(false);
                Ext.Msg.alert("Login Error", "The email-password combination is invalid");
            }
        });

    },

    destroyAuthentication: function() {
        var me = this; 
        me.getViewport().setLoading( 'Logging out..' ) ;
        console.log('Logging out...');
        Ext.Ajax.request({
            url: '/api/users/sign_out',
            method: 'DELETE',
            headers: {'Accept':'application/vnd.neodocapi.v1' },
            params: {
            },
            jsonData: {},
            success: function(result, request ) {
                // me.getViewport().setLoading( false ) ;
                me.currentUser  = null; 
                localStorage.removeItem('neodocUser');

                window.location.reload();
            },
            failure: function(result, request ) {
                me.getViewport().setLoading( false ) ;
                Ext.Msg.alert("Logout Error", "Can't Logout");
            }
        });
    },

    onLoggedin: function(userrecord) {
        console.log("in authentication loggedin");

        Ext.create( "NeoDoc.view.MyViewport1");


        var txt = Ext.getCmp('mainviewport').down('#loggedintext');

        txt.data = userrecord;

        var user = userrecord.username;

        console.log(txt);

        txt.show();


        txt.setText("Logged in as "+user+" role ");
        var task = {
            run: function(){
                console.log('Running verifyUser task');
                var currentUserBase = localStorage.getItem('neodocUser');
                if (localStorage.getItem('neodocUser')) {
                    Ext.Ajax.request({
                        url: '/api/users/verify',
                        headers: {'Accept':'application/vnd.neodocapi.v1'},
                        method: 'GET',
                        params: {
                            auth_token: Ext.decode(currentUserBase).auth_token
                        },
                        jsonData: {},
                        success: function(result, request ) {
                            return true;
                        },
                        failure: function(result, request ) {
                            console.log('Current User is not properly logged in');
                            console.log(result);
                            localStorage.removeItem('neodocUser');
                            currentUserBase=null;
                            window.location.reload();
                        }
                    });
                }
            },
            interval: 60000 //60 second
        }

        console.log('Setting up task');
        var runner = new Ext.util.TaskRunner();
        runner.start(task); 
    },

    onRefreshClick: function(tool, e, eOpts) {
        var store = Ext.StoreMgr.get('navTreeStore');
        store.load();

    }

});
