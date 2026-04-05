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

// TestBigtableBasic tests creating a basic PRODUCTION Bigtable instance with a single cluster.
func TestBigtableBasic(t *testing.T) {
	t.Parallel()

	retrySleep := 10 * time.Second
	unique := strings.ToLower(random.UniqueId())
	baseName := fmt.Sprintf("basic-%s", unique)
	projectID := mustEnv(t, "GOOGLE_CLOUD_PROJECT")

	tfOptions := &terraform.Options{
		TerraformDir: "../examples/bigtable/basic",
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
