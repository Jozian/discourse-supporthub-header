import Component from "@glimmer/component";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";

/**
 * The SupportHub header injected next to the forum logo.
 *
 * Converted from `supporthub.hbs` because Discourse removed the `.hbs`
 * extension for themes and plugins in `2026.8.0-latest`; `2026.7` ESR was
 * the last release that loaded it.
 * See https://meta.discourse.org/t/398896.
 *
 * `htmlSafe` replaces the old `{{{triple-stache}}}`, and it is an assertion
 * that we trust this value unescaped. What we are trusting:
 *
 *   `site.supporthub_header_html` is fetched server-side by `plugin.rb`
 *   from `<hub host>/discourse/header` — the hub's OWN route
 *   (`apps/web/src/routes/discourse-embed.ts`), which builds the fragment
 *   from tenant page rows and passes every interpolated value through
 *   `escapeHtml`. It emits no `<script>`. No forum user, and no hub user,
 *   can put raw markup into it.
 *
 *   The one way to redirect that trust is the `supporthub_header_override_url`
 *   site setting, which changes WHICH host is fetched. Site settings are
 *   admin-only by definition and this one is `client: false`, so it is not
 *   even readable by non-staff — but it does mean a forum admin can point
 *   the fetch at any host and have its HTML inlined unescaped. That is the
 *   boundary; it is admin-only, and it is deliberate.
 */
export default class SupporthubHeader extends Component {
  @service site;
  @service siteSettings;

  get headerHtml() {
    // `?? ""` because `htmlSafe(undefined)` renders the string "undefined",
    // whereas `{{{undefined}}}` rendered nothing. The attribute is absent
    // whenever the remote fetch failed or the plugin was just enabled.
    return htmlSafe(this.site.supporthub_header_html ?? "");
  }

  <template>
    {{#if this.siteSettings.supporthub_header_enabled}}
      <div class="supporthub-plugin">
        {{this.headerHtml}}
      </div>
    {{/if}}
  </template>
}
