package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestBigtableMultiCluster tests a PRODUCTION Bigtable instance with two clusters for replication.
func TestBigtableMultiCluster(t *testing.T) {
	t.Parallel()

	retrySleep := 10 * time.Second
	unique := strings.ToLower(random.UniqueId())
	baseName := fmt.Sprintf("multi-%s", unique)
	projectID := mustEnv(t, "GOOGLE_CLOUD_PROJECT")

	tfOptions := &terraform.Options{
		TerraformDir: "../examples/bigtable/multi-cluster",
		NoColor:      true,
		Vars: map[string]interface{}{
			"project_code": "tt",
			"base_name":    baseName,
			"environment":  "dev",
			"region":       "us-central1",
		},
		EnvVars: map[string]string{
			"GOOGLE_CLOUD_PROJECT": projectID,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	instanceName := terraform.Output(t, tfOptions, "instance_name")
	require.NotEmpty(t, instanceName)

	instanceType := terraform.Output(t, tfOptions, "instance_type")
	require.Equal(t, "PRODUCTION", instanceType)
}
