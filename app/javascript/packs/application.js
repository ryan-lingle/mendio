import "bootstrap";
import { executePodcastSearch } from '../packs/podcast';
import { modal } from '../packs/modal';
import { star } from '../packs/star'
import { tabPicker } from '../packs/tab_picker'
import { cancelForm } from '../packs/cancel_form'
executePodcastSearch();
star();
tabPicker();
cancelForm();
