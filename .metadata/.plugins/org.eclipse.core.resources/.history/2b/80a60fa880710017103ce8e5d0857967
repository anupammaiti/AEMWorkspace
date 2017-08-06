/*
 * Copyright 1997-2009 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 */

CQ.Ext.ns("CQ.foundation");
CQ.Ext.ns("CQ.foundation.mvt");

CQ.foundation.mvt.StatisticsGrid = CQ.Ext.extend(CQ.Ext.grid.GridPanel, {

    path: '',

    store: new CQ.Ext.data.Store({
        "proxy": new CQ.Ext.data.HttpProxy({ "url":"/libs/wcm/mvt/stats", "method":"GET" }),
        "reader": new CQ.Ext.data.JsonReader({
            "totalProperty":"results",
            "root":"banners",
            "id":"bannerPath" },
                [ "bannerPath", "bias", "impr", "ct", "ctr" ]),
        "baseParams": { "_charset_":"utf-8"},
        "listeners": {
            "load": function() {
                this.sort("ctr", "DESC");
            }
        }}),

    colModel: new CQ.Ext.grid.ColumnModel({
        columns:[{
            dataIndex:'bannerPath',
            sortable: true,
            header:'',
            width:70,
            renderer: function(value) {
                return "<img src=\"" + CQ.shared.HTTP.getXhrHookedURL(value + "/jcr:content/renditions/cq5dam.thumbnail.48.48.png") + "\"/>";
            }
        },{
            dataIndex:'ctr',
            sortable: true,
            header:'CTR',
            renderer: function(value) {
                return "<b>" + value + " %</b>";
            }
        },{
            dataIndex:'impr',
            sortable: true,
            header: CQ.I18n.getMessage('Impressions')
        },{
            dataIndex:'ct',
            sortable: true,
            header: CQ.I18n.getMessage('Click-throughs')
        },{
            dataIndex:'bias',
            sortable: true,
            header: CQ.I18n.getMessage('Bias')
        }]
    }),

    constructor : function(config){
        config = CQ.Util.applyDefaults(config, {
            store: this.store,
            colModel: this.colModel,
            stripeRows: true,
            autoHeight: true
        });
        CQ.foundation.mvt.StatisticsGrid.superclass.constructor.call(this, config);
    },

    initComponent: function() {
        CQ.foundation.mvt.StatisticsGrid.superclass.initComponent.call(this);

        var currentObj = this;
        this.on("render", function() {
            this.parentDialog = this.findParentByType("dialog");
            if (this.parentDialog) {
                this.parentDialog.on("loadcontent", function(e) {
                    currentObj.loadStats(this.path);
                }, this.parentDialog);
            }
        }, this);
    },

    // private
    loadStats: function(path) {
        this.path = path;
        this.refreshStats();
    },

    refreshStats: function() {
        this.getStore().load({
            params: {"path":this.path}
        });
    },

    getPath: function() {
        return this.path;
    }

});

CQ.foundation.mvt.StatisticsPanel = CQ.Ext.extend(CQ.Ext.Panel, {

    statsGrid: new CQ.foundation.mvt.StatisticsGrid(),

    constructor: function(config) {
        var currentObj = this;
        config = CQ.Util.applyDefaults(config, {
            bodyBorder: false,
            items: [this.statsGrid],
            bbar:[{
                text: CQ.I18n.getMessage("Reset Statistics"),
                handler: function() {
                    CQ.HTTP.get('/libs/wcm/mvt/stats/clear?path=' + encodeURIComponent(currentObj.statsGrid.getPath()),
                            function() {
                                currentObj.statsGrid.refreshStats();
                            });
                }
            }]
        });
        CQ.foundation.mvt.StatisticsPanel.superclass.constructor.call(this, config);
    },

    onRender : function(ct, position){
        CQ.foundation.mvt.StatisticsPanel.superclass.onRender.call(this, ct, position);
    }
});

CQ.Ext.reg("mvtstatistics", CQ.foundation.mvt.StatisticsPanel);
