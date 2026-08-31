import Component from "@glimmer/component";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";

/**
 * The SupportHub links block above the forum sidebar sections.
 *
 * Converted from `sidelinks.hbs` — same reason and same trust boundary as
 * `home-logo/supporthub.gjs`; `site.supporthub_sidebar_links` comes from the
 * hub's `/discourse/links` route, escaped the same way.
 */
export default class SupporthubSidelinks extends Component {
  @service site;

  get sidebarLinks() {
    return htmlSafe(this.site.supporthub_sidebar_links ?? "");
  }

  <template>
    <div class="supporthub-plugin">
      <div class="supporthub-links sidebar-sections">
        {{this.sidebarLinks}}
      </div>
    </div>
  </template>
}
