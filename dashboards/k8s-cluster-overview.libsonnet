// Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local grafana = import 'grafonnet/grafana.libsonnet';

local dashboard = grafana.dashboard;
local row = grafana.row;
local prometheus = grafana.prometheus;
local template = grafana.template;
local graphPanel = grafana.graphPanel;
local tablePanel = grafana.tablePanel;
local textPanel = grafana.text;
local gaugePanel = grafana.gaugePanel;
local singlestat = grafana.singlestat;

local singlestatHeight = 100;
local singlestatGuageHeight = 150;

{
  grafanaDashboards+:: {
    'k8sclusteroverview.json':
      
      local kubeVersion = textPanel.new(
        mode='html',
        datasource='$datasource',
        content="<div class=\"text-center\">\n  <img style=\"height:80px\" src=\"https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/1200px-Kubernetes_logo_without_workmark.svg.png\">\n  <h2 style=\"padding-top:15px\">$k8s_version</h2>\n</div>",
      );

      local nodesHealthy = singlestat.new(
        'Healthy Nodes',
        datasource='$datasource',
        sparklineShow=true,
      )
      .addTarget(
        prometheus.target(
          'count(kube_node_spec_unschedulable{job="kube-state-metrics"}==0)',
        )
      );

      local nodesUnhealthy = singlestat.new(
        'Unealthy Nodes',
        datasource='$datasource',
        sparklineShow=true,
      )
      .addTarget(
        prometheus.target(
          'count(kube_node_spec_unschedulable{job="kube-state-metrics"}!=0) OR on() vector(0)',
        )
      );

      local nodesPanel = graphPanel.new(
        'Nodes',
        datasource='$datasource',
        format='short',
      )
      .addTarget(
        prometheus.target(
          'sum(kube_node_info{job="kube-state-metrics"})',
        )
      );

      local memUsedStat = singlestat.new(
        'Memory Used',
        datasource='$datasource',
        format='bytes',
        postfixFontSize="50%",
        prefixFontSize="50%",
        valueFontSize="50%",
      )
      .addTarget(
        prometheus.target(
          'SUM(container_memory_usage_bytes{image!=""})',
        )
      );
      local memTotalStat = singlestat.new(
        'Memory Total',
        datasource='$datasource',
        format='bytes',
        postfixFontSize="50%",
        prefixFontSize="50%",
        valueFontSize="50%",
      )
      .addTarget(
        prometheus.target(
          'sum(machine_memory_bytes)',
        )
      );
      local memUsagePanel = gaugePanel.new(
        "Cluster memory usage"
      )
      .addTarget(
        prometheus.target(
          'sum (container_memory_usage_bytes{image!=""}) / sum (machine_memory_bytes) * 100',
        )
      )
      .addThresholds([
        { color: 'green', value: 0 },
        { color: 'yellow', value: 75 },
        { color: 'red', value: 90 },
      ]);

      local cpuUsedStat = singlestat.new(
        'CPU Used',
        datasource='$datasource',
        postfixFontSize="50%",
        prefixFontSize="50%",
        valueFontSize="50%",
      )
      .addTarget(
        prometheus.target(
          'sum(rate(container_cpu_usage_seconds_total{container_name!="POD",image!=""}[5m]))',
        )
      );
      local cpuTotalStat = singlestat.new(
        'CPU Total',
        datasource='$datasource',
        postfixFontSize="50%",
        prefixFontSize="50%",
        valueFontSize="50%",
      )
      .addTarget(
        prometheus.target(
          'sum(machine_cpu_cores)',
        )
      );
      local cpuUsagePanel = gaugePanel.new(
        "Cluster CPU usage"
      )
      .addTarget(
        prometheus.target(
          'sum (rate(container_cpu_usage_seconds_total{id="/"}[1m])) / sum (machine_cpu_cores) * 100',
        )
      )
      .addThresholds([
        { color: 'green', value: 0 },
        { color: 'yellow', value: 75 },
        { color: 'red', value: 90 },
      ]);

      local storageUsedStat = singlestat.new(
        'Storage Used',
        datasource='$datasource',
        format='bytes',
        postfixFontSize="50%",
        prefixFontSize="50%",
        valueFontSize="50%",
      )
      .addTarget(
        prometheus.target(
          'sum(container_fs_usage_bytes{device=~"^/dev/.*$",id="/"})',
        )
      );
      local storageTotalStat = singlestat.new(
        'Storage Total',
        datasource='$datasource',
        format='bytes',
        postfixFontSize="50%",
        prefixFontSize="50%",
        valueFontSize="50%",
      )
      .addTarget(
        prometheus.target(
          'sum(container_fs_limit_bytes{device=~"^/dev/.*$",id="/"})',
        )
      );
      local storageUsagePanel = gaugePanel.new(
        "Cluster Storage usage"
      )
      .addTarget(
        prometheus.target(
          'sum (container_fs_usage_bytes{device=~"^.*$",id="/"}) / sum (container_fs_limit_bytes{device=~"^.*$",id="/"}) * 100',
        )
      )
      .addThresholds([
        { color: 'green', value: 0 },
        { color: 'yellow', value: 75 },
        { color: 'red', value: 90 },
      ]);

      local clusterCpuPanel = graphPanel.new(
        'Cluster CPUs',
        datasource='$datasource',
        format='short',
      )
      .addTarget(
        prometheus.target(
          'SUM(kube_node_status_capacity_cpu_cores)',
          legendFormat="capacity"
        )
      )
      .addTarget(
        prometheus.target(
          'SUM(kube_pod_container_resource_requests_cpu_cores)',
          legendFormat="requests"
        )
      )
      .addTarget(
        prometheus.target(
          'SUM(irate(container_cpu_usage_seconds_total{id=\"/\"}[5m]))',
          legendFormat="usage"
        )
      )
      .addTarget(
        prometheus.target(
          'SUM(kube_pod_container_resource_limits_cpu_cores)',
          legendFormat="limits"
        )
      );
      local clusterMemPanel = graphPanel.new(
        'Cluster Memory',
        datasource='$datasource',
        format='short',
      )
      .addTarget(
        prometheus.target(
          'SUM(kube_node_status_capacity_memory_bytes / 1024 / 1024 / 1024)',
          legendFormat="capacity"
        )
      )
      .addTarget(
        prometheus.target(
          'SUM(kube_pod_container_resource_requests_memory_bytes{namespace!=\"\"} / 1024 / 1024 / 1024)',
          legendFormat="requests"
        )
      )
      .addTarget(
        prometheus.target(
          'SUM(container_memory_usage_bytes{image!=\"\"} / 1024 / 1024 / 1024)',
          legendFormat="usage"
        )
      )
      .addTarget(
        prometheus.target(
          'SUM(kube_pod_container_resource_limits_memory_bytes {namespace!=\"\"} / 1024 / 1024 / 1024)',
          legendFormat="limits"
        )
      );
          
      // Dashboard

      

      dashboard.new(
        '%(prefix)sKubernetes cluster Overview' % $._config.grafanaK8s,
        time_from='now-24h',
        tags=($._config.grafanaK8s.tags),
        editable=true,
      )
      .addTemplate(
        {
          current: {
            text: 'default',
            value: 'default',
          },
          hide: 0,
          label: null,
          name: 'datasource',
          options: [],
          query: 'prometheus',
          refresh: 1,
          regex: '',
          type: 'datasource',
        },
      )
      .addTemplate(
        {
          current: {
            text: 'default',
            value: 'default',
          },
          hide: 0,
          label: null,
          name: 'k8s_version',
          options: [],
          datasource: '$datasource',
          query: 'label_values(kube_node_info, kubelet_version)',
          refresh: 1,
          regex: '',
          type: 'query',
        },
      )
      .addPanel(kubeVersion, gridPos={ h: 4, w: 3, x: 0, y: 0 })
      .addPanel(memUsedStat, gridPos={ h: 2, w: 3, x: 6, y: 0 })
      .addPanel(memTotalStat, gridPos={ h: 2, w: 3, x: 9, y: 0 })
      .addPanel(cpuUsedStat, gridPos={ h: 2, w: 3, x: 12, y: 0 })
      .addPanel(cpuTotalStat, gridPos={ h: 2, w: 3, x: 15, y: 0 })
      .addPanel(storageUsedStat, gridPos={ h: 2, w: 3, x: 18, y: 0 })
      .addPanel(storageTotalStat, gridPos={ h: 2, w: 3, x: 21, y: 0 })
      .addPanel(nodesHealthy, gridPos={ h: 2, w: 3, x: 3, y: 3 })
      .addPanel(nodesUnhealthy, gridPos={ h: 2, w: 3, x: 3, y: 6 })
      .addPanel(memUsagePanel, gridPos={ h: 8, w: 6, x: 6, y: 2 })
      .addPanel(cpuUsagePanel, gridPos={ h: 8, w: 6, x: 12, y: 2 })
      .addPanel(storageUsagePanel, gridPos={ h: 8, w: 6, x: 18, y: 2 })
      .addPanel(nodesPanel, gridPos={ h: 6, w: 6, x: 0, y: 7 })
      .addPanel(clusterCpuPanel, gridPos={ h: 12, w: 12, x: 0, y: 14 })
      .addPanel(clusterMemPanel, gridPos={ h: 12, w: 12, x: 12, y: 14 })
      + { refresh: $._config.grafanaK8s.refresh },
  },
}
