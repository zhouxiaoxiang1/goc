/*
 Copyright 2020 Qiniu Cloud (qiniu.com)

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

package cmd

import (
	"fmt"
	"os"

	log "github.com/sirupsen/logrus"

	"github.com/zhouxiaoxiang1/goc/pkg/cover"
	"github.com/spf13/cobra"
)

var removeCmd = &cobra.Command{
	Use:   "remove",
	Short: "Remove the specified service from the register center.",
	Long:  `Remove the specified service from the register center, after that, goc profile will not collect coverage data from this service anymore`,
	Example: `
# Remove the service 'mongo' from the default register center http://127.0.0.1:7777.
goc remove --service=mongo

# Remove the service 'http://127.0.0.1:53' from the specified register center.
goc remove --address="http://127.0.0.1:53" --center=http://192.168.1.1:8080
`,
	Run: func(cmd *cobra.Command, args []string) {
		p := cover.ProfileParam{
			Service: svrList,
			Address: addrList,
		}
		res, err := cover.NewWorker(center).Remove(p)
		if err != nil {
			log.Fatalf("call host %v failed, err: %v, response: %v", center, err, string(res))
		}
		fmt.Fprint(os.Stdout, string(res))
	},
}

func init() {
	addBasicFlags(removeCmd.Flags())
	removeCmd.Flags().StringSliceVarP(&svrList, "service", "", nil, "service name to clear profile, see 'goc list' for all services.")
	removeCmd.Flags().StringSliceVarP(&addrList, "address", "", nil, "address to clear profile, see 'goc list' for all addresses.")
	rootCmd.AddCommand(removeCmd)
}
