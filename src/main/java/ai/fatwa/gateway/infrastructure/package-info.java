/**
 * Infrastructure layer — framework adapters and external system integrations.
 *
 * <p>This layer contains all concrete implementations that depend on frameworks
 * (Spring, Hibernate Reactive, Vert.x, etc.) and external systems (databases,
 * caches, message brokers). Sub-packages are organized by concern:</p>
 * <ul>
 *   <li>{@code config/} — Vault, Consul, WebFlux, Valkey, Hibernate Reactive configurations</li>
 *   <li>{@code persistence/} — Database adapters, entities, and repositories</li>
 *   <li>{@code web/} — REST controllers (inbound adapters)</li>
 *   <li>{@code messaging/} — Event-driven adapters (future)</li>
 * </ul>
 */
package ai.fatwa.gateway.infrastructure;
