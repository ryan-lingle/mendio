import "bootstrap";
import { executePodcastSearch } from '../packs/podcast';
import { modal } from '../packs/modal';
import { star } from '../packs/star'
import { tabPicker } from '../packs/tab_picker'
executePodcastSearch();
star();
tabPicker();
