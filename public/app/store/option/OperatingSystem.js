/**
 * Store for managing car OperatingSystem
 */
Ext.define('NeoDoc.store.option.OperatingSystem', {
    extend: 'NeoDoc.store.option.Base',
    alias: 'store.option.operatingsystem',
    requires: [
        'NeoDoc.model.option.OperatingSystem'
    ],
    headers: {'Accept':'application/vnd.neodocapi.v1' },
    restPath: '/api/operatingsystems',
    storeId: 'OperatingSystem',
    model: 'NeoDoc.model.option.OperatingSystem'
});