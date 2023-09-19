# config/initializers/datadog-tracer.rb
Datadog.configure do |c|
  c.env = 'development'
  c.service = 'document check'
  c.tracing.sampling.default_rate = 1.0
  c.appsec.enabled = true
  c.agent.host = '18.130.247.224'
  c.agent.port = 8126
end
