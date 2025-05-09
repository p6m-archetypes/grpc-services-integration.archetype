let context = #{};

if switch_enabled("debug-answers") {
    log(Info, `${archetect::archetype::description()} Answers:`);
    display(as_yaml(ANSWERS));
}

context += ANSWERS;


context += prompt("List of gRPC Services to Integrate (example: user-service, stripe-adapter):", "grpc-service-names", #{
        type: List,
        cases: [
            FixedKeyCasedValue("service-name", LowerCase),
        ],
    });

if (context["grpc-service-names"] != () && context["grpc-service-names"].len > 0) {
    context.set("use-default-service", false);
    context.services = create_services(context);    
} else {
    context.set("use-default-service", true);
    context.services = default_services(context);
}


if switch_enabled("debug-context") {
    log(Info, `${archetect::archetype::description()} Context:`);
    display(as_yaml(context));
}

fn create_services (context) {
    let services = #{};
    let port = 5030;
    for service in context["grpc-service-names"] {
        let service_name = service["service-name"];
        let result = to_prefix_suffix(service_name);

        let service_context = create_service_context(result.first, result.second, port);

        services += create_service(service_context); 
        port += 10;
    }
    
    services
}

fn to_prefix_suffix (service_name) {
    let parts = service_name.split("-");

    if parts.len < 2 {
        return #{ first: service_name, second: "service" };
    } else {
        let first = service_name[0 .. service_name.len - parts[parts.len - 1].len - 1];
        let second = parts[parts.len - 1];

        return #{ first: first, second: second };
    }
}

fn create_service (context) {
    let yaml = `
---
${context["project-name"]}:
  ProjectName: ${context["ProjectName"]}
  project-name: ${context["project-name"]}
  service-port: ${context["service-port"]}
  model:
    entities:
      ${context["project-prefix"]}:
        fields:
          id:
            optional: false
            type: String
          name:
            optional: false
            type: String
`;
    let model = from_yaml(yaml);
    model
}

fn default_services(context) {
    let default_service_name = `${context["project-prefix"]}-service`;
    let context = #{
        "grpc-service-names": [
            #{
                "service-name": default_service_name
            }
        ]
    };

    create_services(context)
}

fn create_service_context(prefix, suffix, port) {
    let service_context = #{};
    service_context += set("project-prefix", prefix, #{
        cases: [
            CasedIdentityCasedValue(PROGRAMMING_CASES),
        ]
    });
    service_context += set("project-suffix", suffix, #{
        cases: [
            CasedIdentityCasedValue(PROGRAMMING_CASES),
        ]
    });
    service_context += set("project-name", render("{{project-prefix}}-{{project-suffix}}", service_context), #{
        cases: [
            CasedIdentityCasedValue(PROGRAMMING_CASES),
        ],
    });

    service_context += set("service-port", port);

    service_context
}

context


