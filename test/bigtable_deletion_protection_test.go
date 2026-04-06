package test

import (
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestBigtableDeletionProtection tests a Bigtable instance with deletion_protection enabled.
// The test disables deletion_protection before destroy to allow clean teardown.
func TestBigtableDeletionProtection(t *testing.T) {
	t.Parallel()

	retrySleep := 10 * time.Second
	unique := strings.ToLower(random.UniqueId())
	baseName := unique
	projectID := mustEnv(t, "GOOGLE_CLOUD_PROJECT")

	tfOptions := &terraform.Options{
		TerraformDir: "../examples/bigtable/deletion-protection",
		NoColor:      true,
		Vars: map[string]interface{}{
			"project_code": "tt",
			"base_name":    baseName,
			"environment":  "prod",
			"region":       "us-central1",
		},
		EnvVars: map[string]string{
			"GOOGLE_CLOUD_PROJECT": projectID,
		},
	}

	// Disable deletion protection before destroying to allow clean teardown
	defer func() {
		tfOptionsDestroy := &terraform.Options{
			TerraformDir: "../examples/bigtable/deletion-protection",
			NoColor:      true,
			Vars: map[string]interface{}{
				"project_code": "tt",
				"base_name":    baseName,
				"environment":  "prod",
				"region":       "us-central1",
			},
			EnvVars: map[string]string{
				"GOOGLE_CLOUD_PROJECT": projectID,
			},
		}
		terraform.Destroy(t, tfOptionsDestroy)
	}()

	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	instanceName := terraform.Output(t, tfOptions, "instance_name")
	require.NotEmpty(t, instanceName)

	deletionProtection := terraform.Output(t, tfOptions, "instance_deletion_protection")
	require.Equal(t, "true", deletionProtection)
}
