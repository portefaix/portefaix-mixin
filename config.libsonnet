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

{
  _config+:: {
    grafanaExternalUrl: 'https://grafana.portefaix.xyz',
    runbookURLPattern: 'https://github.com/portefaix/portefaix-mixin/tree/master/runbook.md#alert-name-%s',

    // Severity level for NodeRebootted alert
    nodeRebootedSeverity: 'warning',

    // Grafana dashboard IDs are necessary for stable links for dashboards
    grafanaDashboardIDs: {
      'cluster-cost.json': 'ieyahc4arahsieweequah8ughaixohchath8waeGh',
    },

    // // Config for the Grafana dashboards in the Mixin
    grafanaK8s: {
      prefix: 'Portefaix / ',
      tags: ['portefaix-mixin'],

      // The default refresh time for all dashboards, default to 10s
      refresh: '60s',
      // minimumTimeInterval: '1m',
    },

  },
  
}
