# YAML-Commiter

Using [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) as my CD tool and respecting their best practices about separating k8s manifests from source code, I often need to update a YAML file in another Git repo during my CI pipelines to update the version of my image and trigger a deployment

That's the purpose of this docker image

## Parameters

- `--url`: [*Mandatory*] The URL of the repository to clone
- `--name`: [*Mandatory*] The name of the folder where the repo will be clone (should be the last part of the url)
- `--key`: [*Mandatory*] The key to update in the yaml
- `--value`: [*Mandatory*] The value to set on the key
- `--user`: [*Optional: default is __YamlCommiter__*] commiter name
- `--email`: [*Optional: default is __yamlcommiter@example.com__*] commiter email

## Example

```bash
docker run varkal/yaml-committer --url https://github.com/myRepo --name myRepo --key backVersion --value 1.2.3 --user "Varkal" --email "myemail@example.com" --file my_file.yaml
```
