/**
 * Store for managing OsVersions
 */
Ext.define('NeoDoc.store.option.OsVersion', {
    extend: 'NeoDoc.store.option.Base',
    alias: 'store.option.osversion',
    requires: [
        'NeoDoc.model.option.OsVersion'
    ],
    headers: {'Accept':'application/vnd.neodocapi.v1' },
    restPath: '/api/osvers',
    storeId: 'OsVersions',
    model: 'NeoDoc.model.option.OsVersion'
});