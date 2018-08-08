import "bootstrap";
import { executePodcastSearch } from '../packs/podcast';
import { modal } from '../packs/modal';
import { star } from '../packs/star'
import { tabPicker } from '../packs/tab_picker'
import { cancelForm } from '../packs/cancel_form'
import { createView } from '../packs/create_view'
import { stripe } from '../packs/stripe'
import { podcastTabs } from '../packs/podcast_tabs'
import { toggleFollow } from '../packs/toggle_follow'

executePodcastSearch();
star();
tabPicker();
createView();
modal();
stripe();
podcastTabs();
toggleFollow();
