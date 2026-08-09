# Credits

Diatona's own source code and data files are MIT licensed (see [LICENSE](LICENSE)).
The material below belongs to third parties and keeps its own terms.

## Audio assets

### Piano samples: `assets/instrument_sounds/piano/`

| | |
| --- | --- |
| Author | Lawrence Fritts, University of Iowa Electronic Music Studios |
| Source | <https://theremin.music.uiowa.edu/MIS.html> |
| Files | `piano_mf_*.mp3` (36 notes) |
| Terms | "Since 1997, these recordings have been freely available on this website and may be downloaded and used for any projects, without restrictions." |

The recordings remain the University of Iowa's work and are redistributed here
under that grant rather than under Diatona's MIT license. The grant is
unrestricted and covers commercial use, so forks of this project need no extra
permission, since the same terms reach them directly from the source. Credit is not
required; it is given here because the recordings deserve it.

## Software dependencies

Diatona is built with Flutter and the Dart packages listed in
[pubspec.yaml](pubspec.yaml). All of them are permissively licensed:

| License | Packages |
| --- | --- |
| BSD-3-Clause | Flutter and Dart SDK, `record`, `pitch_detector_dart`, `url_launcher`, `shared_preferences`, `wakelock_plus`, `intl`, and most transitive packages |
| MIT | `audioplayers`, `flutter_riverpod`, `riverpod`, `state_notifier`, `cupertino_icons`, `synchronized`, `uuid`, `xml`, `yaml`, `petitparser` |
| Apache-2.0 | `clock`, `fake_async`, `material_color_utilities` |
| MPL-2.0 | `dbus` (transitive, Linux only, via `wakelock_plus`) |

None of these impose copyleft obligations on Diatona's own code. The full,
generated notices for every bundled package are available in the app under
**Credits → Open source licenses**.

## Reference material

The theory and chord data under `database/` was written for this
project. Where it describes named systems (CAGED, standard voicings, common
repertoire), it describes commonly documented musical practice rather than
reproducing any specific copyrighted text.
