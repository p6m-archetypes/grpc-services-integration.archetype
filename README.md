# Java Project Attributes

This is an [Archetect](https://archetect.github.io/) archetype.

## Rendering

To generate content from this Archetype, copy and execute the following command:

```sh
  archetect render git@github.com:p6m-archetypes/grpc-services-integration.archetype.git
```

## Archetype Layout

Archetect has flexibility in how an archetype is laid out. However, the defaults,
as used in this archetype, should cover the vast majority of cases.

### Archetype Configuration

The `~/.archetype.yaml` manifest contains configuration for this archetype,
including:

- The minimum `Archetect` version required to render this archetype (required).
- Any component Archetypes this archetype may compose (optional).
- Customized locations for the main script, content root directory, templating
  macros and layouts directory, and scripting modules directory (optional).

### Archetype Script

The `./archetype.rhai` script contains the logic for building gRPC services list to integrate.
Prompting the user to input list of gRPC services.
For example:
- foo-service
- bar-adapter

### Output context
- `grpc-service-names`-  input list of gRPC Service Names to integrate
- `services` - gRPC service model with default entity model (id, name)
- `use-default-service` - boolean when any service name is specified, `service` will have default implementation with the name of `project-prefix` of your caller context.

#### Example of Output context for `grpc-service-names`=["foo-service", "bar-adapter"]
```yaml
grpc-service-names:
- service-name: foo-service
- service-name: bar-adapter
project-prefix: sample
services:
  bar-adapter:
    ProjectName: BarAdapter
    model:
      entities:
        bar:
          fields:
            id:
              optional: false
              type: String
            name:
              optional: false
              type: String
    project-name: bar-adapter
    service-port: 5040
  foo-service:
    ProjectName: FooService
    model:
      entities:
        foo:
          fields:
            id:
              optional: false
              type: String
            name:
              optional: false
              type: String
    project-name: foo-service
    service-port: 5030
use-default-service: false
```

#### Example of Output context for Default (No gRPC Services provided), `-a project-prefix=sample`
```yaml
grpc-service-names: []
project-prefix: sample
services:
  sample-service:
    ProjectName: SampleService
    model:
      entities:
        sample:
          fields:
            id:
              optional: false
              type: String
            name:
              optional: false
              type: String
    project-name: sample-service
    service-port: 5030
use-default-service: true
```