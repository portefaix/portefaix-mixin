// Copyright (C) Nicolas Lamirault <nicolas.lamirault@gmail.com>
//
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

// Copyright (C) Nicolas Lamirault <nicolas.lamirault@gmail.com>
//
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

// Copyright (C) Nicolas Lamirault <nicolas.lamirault@gmail.com>
//
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

    // Config for the Grafana dashboards in the Mixin
    grafanaK8s: {
      // Grafana tags
      tags: ['portefaix-mixin-v0.2.0'],

      // Timezone for Grafana dashboards:: UTC, browser, ...
      grafanaTimezone: 'UTC',

      // The default refresh time for all dashboards, default to 30s
      refresh: '60s',

      // minimumTimeInterval: '1m',
    },

  },

}
