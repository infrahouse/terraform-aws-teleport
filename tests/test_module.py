import json
from os import path as osp
from textwrap import dedent

from pytest_infrahouse import terraform_apply

from tests.conftest import (
    LOG,
    TERRAFORM_ROOT_DIR,
)


def test_module(
    service_network,
    test_role_arn,
        test_zone_name,
    keep_after,
    aws_region,
):
    backend_subnet_ids = service_network["subnet_private_ids"]["value"]
    frontend_subnet_ids = service_network["subnet_public_ids"]["value"]

    terraform_module_dir = osp.join(TERRAFORM_ROOT_DIR, "teleport")
    with open(osp.join(terraform_module_dir, "terraform.tfvars"), "w") as fp:
        fp.write(
            dedent(
                f"""
                    region              = "{aws_region}"
                    backend_subnet_ids  = {json.dumps(backend_subnet_ids)}
                    frontend_subnet_ids = {json.dumps(frontend_subnet_ids)}
                    zone_name           = "{test_zone_name}"
                    """
            )
        )
        if test_role_arn:
            fp.write(
                dedent(
                    f"""

                    role_arn = "{test_role_arn}"
                    """
                )
            )

    with terraform_apply(
        terraform_module_dir,
        destroy_after=not keep_after,
        json_output=True,
    ) as tf_output:
        LOG.info("%s", json.dumps(tf_output, indent=4))
