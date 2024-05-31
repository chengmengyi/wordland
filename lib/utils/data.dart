import 'dart:io';

const String questionStr="W3sKInF1ZXN0aW9uIjogIkkgYW0geWVsbG93IGFuZCB5b3UgY2FuIGZpbmQgbWUgaW4gcGllcyIsCiJhbnN3ZXIiOiAiQmFuYW5hIgp9LAp7CiJxdWVzdGlvbiI6ICIgSSBhbSByZWQgYW5kIG9mdGVuIHVzZWQgdG8gbWFrZSBqdWljZSIsCiJhbnN3ZXIiOiAiQXBwbGUiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gZ3JlZW4gYW5kIGhhdmUgYSB0b3VnaCBvdXRlciBza2luIiwKImFuc3dlciI6ICJNZWxvbiIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBzbWFsbCBhbmQgb2Z0ZW4gdXNlZCBpbiBzYWxhZHMiLAoiYW5zd2VyIjogIkdyYXBlcyIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBvcmFuZ2UgYW5kIGhhdmUgYSBzd2VldCBhbmQgdGFuZ3kgZmxhdm9yIiwKImFuc3dlciI6ICJPcmFuZ2UiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gcHVycGxlIGFuZCBrbm93biBmb3IgbXkgYW50aW94aWRhbnQgcHJvcGVydGllcyIsCiJhbnN3ZXIiOiAiQmx1ZWJlcnJ5Igp9LAp7InF1ZXN0aW9uIjogIkkgYW0geWVsbG93IGFuZCBrbm93biBmb3IgbXkgY3VydmVkIHNoYXBlIiwKImFuc3dlciI6ICJCYW5hbmEiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gcmVkIGFuZCBqdWljeSwgb2Z0ZW4gZWF0ZW4gaW4gdGhlIHN1bW1lcnRpbWUiLAoiYW5zd2VyIjogIldhdGVybWVsb24iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0geWVsbG93IGFuZCBoYXZlIGEgc3dlZXQgYW5kIHNvdXIgdGFzdGUiLAoiYW5zd2VyIjogIkxlbW9uIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGdyZWVuIGFuZCBvZnRlbiB1c2VkIGluIGd1YWNhbW9sZSIsCiJhbnN3ZXIiOiAiQXZvY2FkbyIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBzbWFsbCBhbmQga25vd24gZm9yIG15IHRhcnQgZmxhdm9yIiwKImFuc3dlciI6ICJDcmFuYmVycnkiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gcmVkIGFuZCBvZnRlbiB1c2VkIGluIGphbXMgYW5kIGplbGxpZXMiLAoiYW5zd2VyIjogIlN0cmF3YmVycnkiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gcGluayBhbmQgaGF2ZSBhIHN3ZWV0IGFuZCBqdWljeSB0YXN0ZSIsCiJhbnN3ZXIiOiAiR3JhcGVmcnVpdCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBicm93biBhbmQgaGF2ZSBhIGhhcmQgc2hlbGwiLAoiYW5zd2VyIjogIkhhemVsbnV0Igp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGdyZWVuIGFuZCBvZnRlbiB1c2VkIGluIHNhbGFkcyBhbmQgc21vb3RoaWVzIiwKImFuc3dlciI6ICJTcGluYWNoIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIHllbGxvdyBhbmQgaGF2ZSBhIGJ1bXB5IHNraW4iLAoiYW5zd2VyIjogIkxlbW9uIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIG9yYW5nZSBhbmQgaGF2ZSBhIHJvdWdoIG91dGVyIHNraW4iLAoiYW5zd2VyIjogIlBhcGF5YSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBwdXJwbGUgYW5kIG9mdGVuIHVzZWQgaW4gZGVzc2VydHMiLAoiYW5zd2VyIjogIkdyYXBlIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIHJlZCBhbmQgb2Z0ZW4gdXNlZCBpbiBzYXVjZXMgYW5kIGtldGNodXAiLAoiYW5zd2VyIjogIlRvbWF0byIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSB5ZWxsb3cgYW5kIGhhdmUgYSBzd2VldCBhbmQgdGFuZ3kgdGFzdGUiLAoiYW5zd2VyIjogIk1hbmdvIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIHRoZSBraW5nIG9mIHRoZSBqdW5nbGUiLAoiYW5zd2VyIjogIkxpb24iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gdGhlIGxhcmdlc3QgbGFuZCBhbmltYWwiLAoiYW5zd2VyIjogIkVsZXBoYW50Igp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGtub3duIGZvciBteSBibGFjayBhbmQgd2hpdGUgc3RyaXBlcyIsCiJhbnN3ZXIiOiAiWmVicmEiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gdGhlIHRhbGxlc3QgYW5pbWFsIiwKImFuc3dlciI6ICJHaXJhZmZlIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgZG9tZXN0aWNhdGVkIGFuaW1hbCBvZnRlbiBrZXB0IGFzIGEgcGV0IiwKImFuc3dlciI6ICJEb2ciCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBtYXJpbmUgbWFtbWFsIGFuZCBrbm93biBmb3IgbXkgaW50ZWxsaWdlbmNlIiwKImFuc3dlciI6ICJEb2xwaGluIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgbm9jdHVybmFsIGZseWluZyBtYW1tYWwiLAoiYW5zd2VyIjogIkJhdCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGxhcmdlIG1hcmluZSBhbmltYWwgYW5kIGtub3duIGZvciBteSBsb25nIHR1c2tzIiwKImFuc3dlciI6ICJXYWxydXMiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmYXN0LXJ1bm5pbmcgYmlyZCBhbmQga25vd24gZm9yIG15IGxvbmcgbGVncyIsCiJhbnN3ZXIiOiAiT3N0cmljaCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHNtYWxsIG1hbW1hbCBhbmQga25vd24gZm9yIG15IGFiaWxpdHkgdG8gZmx5IiwKImFuc3dlciI6ICJCYXQiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBsYXJnZSBzZWEgY3JlYXR1cmUgYW5kIGtub3duIGZvciBteSBpbnRlbGxpZ2VuY2UiLAoiYW5zd2VyIjogIkRvbHBoaW4iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBkb21lc3RpY2F0ZWQgYW5pbWFsIG9mdGVuIHVzZWQgZm9yIHRyYW5zcG9ydGF0aW9uIiwKImFuc3dlciI6ICJIb3JzZSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHNtYWxsIGNyZWF0dXJlIG9mdGVuIGtlcHQgYXMgYSBwZXQgYW5kIGtub3duIGZvciBteSBhYmlsaXR5IHRvIHNwaW4gd2VicyIsCiJhbnN3ZXIiOiAiU3BpZGVyIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgbGFyZ2UsIGZsaWdodGxlc3MgYmlyZCBuYXRpdmUgdG8gQXVzdHJhbGlhIiwKImFuc3dlciI6ICJFbXUiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBtYXJpbmUgYW5pbWFsIGFuZCBrbm93biBmb3IgbXkgc2hlbGwiLAoiYW5zd2VyIjogIlR1cnRsZSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGxhcmdlLCBoZXJiaXZvcm91cyBtYW1tYWwgd2l0aCBhIGxvbmcgdHJ1bmsiLAoiYW5zd2VyIjogIkVsZXBoYW50Igp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgc21hbGwsIHBpbmsgYmlyZCBrbm93biBmb3Igc3RhbmRpbmcgb24gb25lIGxlZyIsCiJhbnN3ZXIiOiAiRmxhbWluZ28iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSB3aWxkIGZlbGluZSBrbm93biBmb3IgbXkgc3BvdHMiLAoiYW5zd2VyIjogIkxlb3BhcmQiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCwgZnVycnkgbWFtbWFsIG9mdGVuIGtlcHQgYXMgYSBwZXQiLAoiYW5zd2VyIjogIkhhbXN0ZXIiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBsYXJnZSwgYXF1YXRpYyBtYW1tYWwga25vd24gZm9yIG15IHBsYXlmdWwgYmVoYXZpb3IiLAoiYW5zd2VyIjogIkRvbHBoaW4iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBiaXJkIGFuZCBrbm93biBmb3IgbXkgYWJpbGl0eSB0byBtaW1pYyBodW1hbiBzcGVlY2giLAoiYW5zd2VyIjogIlBhcnJvdCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGxhcmdlLCBwcmVkYXRvcnkgY2F0IGFuZCBrbm93biBmb3IgbXkgbWFuZSIsCiJhbnN3ZXIiOiAiTGlvbiIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHNtYWxsLCBjb2xvcmZ1bCBiaXJkIG9mdGVuIGtlcHQgYXMgYSBwZXQiLAoiYW5zd2VyIjogIlBhcmFrZWV0Igp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgcmVwdGlsZSBhbmQga25vd24gZm9yIG15IGFiaWxpdHkgdG8gY2hhbmdlIGNvbG9yIiwKImFuc3dlciI6ICJDaGFtZWxlb24iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBsYXJnZSwgZmxpZ2h0bGVzcyBiaXJkIG5hdGl2ZSB0byBBZnJpY2EiLAoiYW5zd2VyIjogIk9zdHJpY2giCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBsYXJnZSwgYXF1YXRpYyBtYW1tYWwgYW5kIGtub3duIGZvciBteSBsb25nLCBjdXJ2ZWQgdHVza3MiLAoiYW5zd2VyIjogIk5hcndoYWwiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCwgbm9jdHVybmFsIG1hbW1hbCBvZnRlbiBhc3NvY2lhdGVkIHdpdGggSGFsbG93ZWVuIiwKImFuc3dlciI6ICJCYXQiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmYXN0LXJ1bm5pbmcgbGFuZCBhbmltYWwgYW5kIGtub3duIGZvciBteSBzcG90cyIsCiJhbnN3ZXIiOiAiQ2hlZXRhaCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIG1hcmluZSBhbmltYWwgYW5kIGtub3duIGZvciBteSBzaGFycCB0ZWV0aCBhbmQgZG9yc2FsIGZpbiIsCiJhbnN3ZXIiOiAiU2hhcmsiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBsYXJnZSwgaGVyYml2b3JvdXMgbWFtbWFsIGFuZCBrbm93biBmb3IgbXkgaG9ybiIsCiJhbnN3ZXIiOiAiUmhpbm8iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCwgZG9tZXN0aWNhdGVkIGFuaW1hbCBvZnRlbiBrZXB0IGFzIGEgcGV0IGFuZCBrbm93biBmb3IgY2hhc2luZyBtaWNlIiwKImFuc3dlciI6ICJDYXQiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBsYXJnZSwgcHJlZGF0b3J5IGJpcmQgYW5kIGtub3duIGZvciBteSBzaGFycCBiZWFrIGFuZCB0YWxvbnMiLAoiYW5zd2VyIjogIkVhZ2xlIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgbG9uZy1uZWNrZWQgYmlyZCBhbmQga25vd24gZm9yIG156ZW/6IW/IiwKImFuc3dlciI6ICJDcmFuZSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHNtYWxsLCBmdXJyeSBtYW1tYWwgb2Z0ZW4gYXNzb2NpYXRlZCB3aXRoIGNoZWVzZSIsCiJhbnN3ZXIiOiAiTW91c2UiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBtYXJpbmUgbWFtbWFsIGFuZCBrbm93biBmb3IgbXkgYmx1YmJlciBhbmQgZmxpcHBlcnMiLAoiYW5zd2VyIjogIlNlYWwiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCwgdmVub21vdXMgcmVwdGlsZSBvZnRlbiBmb3VuZCBpbiBkZXNlcnRzIiwKImFuc3dlciI6ICJSYXR0bGVzbmFrZSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGxhcmdlLCBoZXJiaXZvcm91cyBtYW1tYWwgYW5kIGtub3duIGZvciBteSBodW1wIiwKImFuc3dlciI6ICJDYW1lbCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHNtYWxsLCBmYXN0LW1vdmluZyBiaXJkIGFuZCBrbm93biBmb3IgbXkgaG92ZXJpbmcgZmxpZ2h0IiwKImFuc3dlciI6ICJIdW1taW5nYmlyZCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIG1hcmluZSBhbmltYWwgYW5kIGtub3duIGZvciBteSBlaWdodCBhcm1zIiwKImFuc3dlciI6ICJPY3RvcHVzIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgbGFyZ2UsIGFxdWF0aWMgbWFtbWFsIGFuZCBrbm93biBmb3IgbXkgYmxvd2hvbGUiLAoiYW5zd2VyIjogIldoYWxlIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgc21hbGwsIG5vY3R1cm5hbCBtYW1tYWwgb2Z0ZW4gYXNzb2NpYXRlZCB3aXRoIHZhbXBpcmVzIiwKImFuc3dlciI6ICJCYXQiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBsYXJnZSwgcHJlZGF0b3J5IGNhdCBhbmQga25vd24gZm9yIG15IHN0cmVuZ3RoIGFuZCBhZ2lsaXR5IiwKImFuc3dlciI6ICJUaWdlciIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHNtYWxsLCBjb2xvcmZ1bCBmaXNoIG9mdGVuIGtlcHQgaW4gYXF1YXJpdW1zIiwKImFuc3dlciI6ICJHb2xkZmlzaCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHJlcHRpbGUgYW5kIGtub3duIGZvciBteSBoYXJkIHNoZWxsIGFuZCBzbG93IG1vdmVtZW50IiwKImFuc3dlciI6ICJUb3J0b2lzZSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGxhcmdlLCBmbGlnaHRsZXNzIGJpcmQgbmF0aXZlIHRvIFNvdXRoIEFtZXJpY2EiLAoiYW5zd2VyIjogIlJoZWEiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCwgZnVycnkgbWFtbWFsIG9mdGVuIGFzc29jaWF0ZWQgd2l0aCBhY29ybnMiLAoiYW5zd2VyIjogIlNxdWlycmVsIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgbWFyaW5lIG1hbW1hbCBhbmQga25vd24gZm9yIG15IHdoaXNrZXJzIiwKImFuc3dlciI6ICJTZWFsIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgYmlyZCBhbmQga25vd24gZm9yIG15IGxvbmcgYmVhayBhbmQgd2FkaW5nIGJlaGF2aW9yIiwKImFuc3dlciI6ICJIZXJvbiIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGxhcmdlLCBoZXJiaXZvcm91cyBtYW1tYWwgYW5kIGtub3duIGZvciBteSBsb25nIG5lY2sgYW5kIHNwb3RzIiwKImFuc3dlciI6ICJHaXJhZmZlIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgc21hbGwsIHZlbm9tb3VzIHJlcHRpbGUgb2Z0ZW4gZm91bmQgaW4gcmFpbmZvcmVzdHMiLAoiYW5zd2VyIjogIkNvYnJhIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgZG9tZXN0aWNhdGVkIGFuaW1hbCBvZnRlbiByYWlzZWQgZm9yIG1pbGsgYW5kIG1lYXQiLAoiYW5zd2VyIjogIkNvdyIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIG1hcmluZSBhbmltYWwgYW5kIGtub3duIGZvciBteSB0ZW50YWNsZXMgYW5kIHN0aW5naW5nIGNlbGxzIiwKImFuc3dlciI6ICJKZWxseWZpc2giCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBsYXJnZSwgYXF1YXRpYyBtYW1tYWwgYW5kIGtub3duIGZvciBteSBsb25nLCBmbGV4aWJsZSBuZWNrIiwKImFuc3dlciI6ICJTZWFob3JzZSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHNtYWxsIGZsb3dlcmluZyBwbGFudCBvZnRlbiBnaXZlbiBvbiBzcGVjaWFsIG9jY2FzaW9ucyIsCiJhbnN3ZXIiOiAiUm9zZSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGZydWl0IHRoYXQgZ3Jvd3Mgb24gYSB2aW5lIGFuZCBpcyBvZnRlbiB1c2VkIHRvIG1ha2Ugd2luZSIsCiJhbnN3ZXIiOiAiR3JhcGUiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBsZWFmeSBncmVlbiB2ZWdldGFibGUgb2Z0ZW4gdXNlZCBpbiBzYWxhZHMiLAoiYW5zd2VyIjogIkxldHR1Y2UiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSB0YWxsIHRyZWUga25vd24gZm9yIG15IGxhcmdlLCBicm9hZCBsZWF2ZXMiLAoiYW5zd2VyIjogIk9hayIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGZsb3dlcmluZyBwbGFudCBvZnRlbiBhc3NvY2lhdGVkIHdpdGggVmFsZW50aW5lJ3MgRGF5IiwKImFuc3dlciI6ICJSb3NlIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgZnJ1aXQgdGhhdCBpcyB5ZWxsb3cgYW5kIHN3ZWV0IGFuZCBvZnRlbiBlYXRlbiBpbiB0aGUgc3VtbWVyIiwKImFuc3dlciI6ICJCYW5hbmEiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBwbGFudCB0aGF0IGdyb3dzIHVuZGVyZ3JvdW5kIGFuZCBpcyBvZnRlbiB1c2VkIGluIGNvb2tpbmciLAoiYW5zd2VyIjogIlBvdGF0byIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGZsb3dlcmluZyBwbGFudCBvZnRlbiBhc3NvY2lhdGVkIHdpdGggd2VkZGluZ3MiLAoiYW5zd2VyIjogIlJvc2UiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmcnVpdCB0aGF0IGlzIHJlZCBhbmQgb2Z0ZW4gdXNlZCB0byBtYWtlIGp1aWNlIiwKImFuc3dlciI6ICJTdHJhd2JlcnJ5Igp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgcGxhbnQgdGhhdCBpcyBvZnRlbiB1c2VkIHRvIG1ha2UgdGVhIiwKImFuc3dlciI6ICJUZWEgcGxhbnQiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSB0cmVlIGtub3duIGZvciBteSB3aGl0ZSBmbG93ZXJzIGFuZCBzdHJvbmcsIGZyYWdyYW50IHNjZW50IiwKImFuc3dlciI6ICJNYWdub2xpYSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGZydWl0IHRoYXQgaXMgb3JhbmdlIGFuZCBvZnRlbiBhc3NvY2lhdGVkIHdpdGggSGFsbG93ZWVuIiwKImFuc3dlciI6ICJQdW1wa2luIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgcGxhbnQgdGhhdCBpcyBvZnRlbiB1c2VkIHRvIG1ha2UgcGFwZXIiLAoiYW5zd2VyIjogIlRyZWUiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmbG93ZXJpbmcgcGxhbnQgb2Z0ZW4gYXNzb2NpYXRlZCB3aXRoIGx1Y2siLAoiYW5zd2VyIjogIkZvdXItbGVhZiBjbG92ZXIiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmcnVpdCB0aGF0IGlzIGdyZWVuIGFuZCBvZnRlbiB1c2VkIGluIHNhbGFkcyIsCiJhbnN3ZXIiOiAiQ3VjdW1iZXIiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBwbGFudCB0aGF0IGlzIG9mdGVuIHVzZWQgdG8gbWFrZSBtZWRpY2luZSBhbmQgc29vdGhlIGJ1cm5zIiwKImFuc3dlciI6ICJBbG9lIHZlcmEiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmbG93ZXJpbmcgcGxhbnQgb2Z0ZW4gYXNzb2NpYXRlZCB3aXRoIENocmlzdG1hcyIsCiJhbnN3ZXIiOiAiUG9pbnNldHRpYSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGZydWl0IHRoYXQgaXMgeWVsbG93IGFuZCBvZnRlbiB1c2VkIHRvIG1ha2UgbGVtb25hZGUiLAoiYW5zd2VyIjogIkxlbW9uIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgcGxhbnQgdGhhdCBpcyBvZnRlbiB1c2VkIGFzIGEgc3BpY2UgaW4gY29va2luZyIsCiJhbnN3ZXIiOiAiQ2lubmFtb24iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSB0cmVlIGtub3duIGZvciBteSBwaW5rIG9yIHdoaXRlIGZsb3dlcnMgaW4gdGhlIHNwcmluZyIsCiJhbnN3ZXIiOiAiQ2hlcnJ5IHRyZWUiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmcnVpdCB0aGF0IGlzIHJlZCBhbmQgb2Z0ZW4gdXNlZCB0byBtYWtlIHNhdWNlIiwKImFuc3dlciI6ICJUb21hdG8iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBwbGFudCB0aGF0IGlzIG9mdGVuIHVzZWQgaW4gaGVyYmFsIHJlbWVkaWVzIGFuZCB0ZWFzIiwKImFuc3dlciI6ICJNaW50Igp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgdHJlZSBrbm93biBmb3IgbXkgdGFsbCBoZWlnaHQgYW5kIG5lZWRsZS1saWtlIGxlYXZlcyIsCiJhbnN3ZXIiOiAiUGluZSB0cmVlIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgdmVnZXRhYmxlIHRoYXQgaXMgb3JhbmdlIGFuZCBvZnRlbiBhc3NvY2lhdGVkIHdpdGggcmFiYml0cyIsCiJhbnN3ZXIiOiAiQ2Fycm90Igp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgcGxhbnQgdGhhdCBpcyBvZnRlbiB1c2VkIHRvIG1ha2UgcGVyZnVtZSBhbmQgZXNzZW50aWFsIG9pbHMiLAoiYW5zd2VyIjogIkxhdmVuZGVyIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgZnJ1aXQgdGhhdCBpcyB5ZWxsb3cgYW5kIGtub3duIGZvciBteSBjdXJ2ZWQgc2hhcGUiLAoiYW5zd2VyIjogIkJhbmFuYSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHBsYW50IHRoYXQgaXMgb2Z0ZW4gdXNlZCBpbiBjb29raW5nIGFuZCBrbm93biBmb3IgbXkgc3Ryb25nIHNtZWxsIiwKImFuc3dlciI6ICJHYXJsaWMiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSB0cmVlIGtub3duIGZvciBteSB3aGl0ZSBiYXJrIGFuZCBwYXBlci1saWtlIHBlZWxpbmciLAoiYW5zd2VyIjogIkJpcmNoIHRyZWUiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSB2ZWdldGFibGUgdGhhdCBpcyBncmVlbiBhbmQgb2Z0ZW4gdXNlZCBpbiBzdGlyLWZyaWVzIiwKImFuc3dlciI6ICJCcm9jY29saSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHBsYW50IHRoYXQgaXMgb2Z0ZW4gdXNlZCB0byBtYWtlIHJvcGVzIGFuZCB0ZXh0aWxlcyIsCiJhbnN3ZXIiOiAiSGVtcCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGZydWl0IHRoYXQgaXMgb3JhbmdlIGFuZCBvZnRlbiBhc3NvY2lhdGVkIHdpdGggdml0YW1pbiBDIiwKImFuc3dlciI6ICJPcmFuZ2UiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBwbGFudCB0aGF0IGlzIG9mdGVuIHVzZWQgdG8gbWFrZSBzYWxzYSBhbmQgZ3VhY2Ftb2xlIiwKImFuc3dlciI6ICJBdm9jYWRvIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgZmxvd2VyaW5nIHBsYW50IG9mdGVuIGFzc29jaWF0ZWQgd2l0aCBFYXN0ZXIiLAoiYW5zd2VyIjogIkxpbHkiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmcnVpdCB0aGF0IGlzIGdyZWVuIGFuZCBrbm93biBmb3IgbXkgc291ciB0YXN0ZSIsCiJhbnN3ZXIiOiAiTGltZSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHBsYW50IHRoYXQgaXMgb2Z0ZW4gdXNlZCBpbiBjb29raW5nIGFuZCBrbm93biBmb3IgbXkgYXJvbWF0aWMgbGVhdmVzIiwKImFuc3dlciI6ICJCYXNpbCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHRyZWUga25vd24gZm9yIG15IGRyb29waW5nIGJyYW5jaGVzIGFuZCB5ZWxsb3cgZmxvd2VycyIsCiJhbnN3ZXIiOiAiV2lsbG93Igp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgdmVnZXRhYmxlIHRoYXQgaXMgZ3JlZW4gYW5kIG9mdGVuIHVzZWQgaW4gc2FuZHdpY2hlcyIsCiJhbnN3ZXIiOiAiTGV0dHVjZSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHBsYW50IHRoYXQgaXMgb2Z0ZW4gdXNlZCBpbiBwZXJmdW1lcyBhbmQga25vd24gZm9yIG15IHN0cm9uZyBmcmFncmFuY2UiLAoiYW5zd2VyIjogIkphc21pbmUiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmcnVpdCB0aGF0IGlzIHJlZCBhbmQgb2Z0ZW4gdXNlZCB0byBtYWtlIGplbGx5IiwKImFuc3dlciI6ICJHcmFwZWZydWl0Igp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgdmVnZXRhYmxlIHRoYXQgaXMgb3JhbmdlIGFuZCBvZnRlbiB1c2VkIGluIHBpZXMiLAoiYW5zd2VyIjogIlB1bXBraW4iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBwbGFudCB0aGF0IGlzIG9mdGVuIHVzZWQgaW4gY29zbWV0aWNzIGFuZCBrbm93biBmb3IgbXkgc29vdGhpbmcgcHJvcGVydGllcyIsCiJhbnN3ZXIiOiAiQWxvZSB2ZXJhIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgZnJ1aXQgdGhhdCBpcyB5ZWxsb3cgYW5kIG9mdGVuIHVzZWQgdG8gbWFrZSBqYW0iLAoiYW5zd2VyIjogIkFwcmljb3QiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBwbGFudCB0aGF0IGlzIG9mdGVuIHVzZWQgaW4gdHJhZGl0aW9uYWwgbWVkaWNpbmUgYW5kIGtub3duIGZvciBteSBjYWxtaW5nIGVmZmVjdHMiLAoiYW5zd2VyIjogIkNoYW1vbWlsZSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHRyZWUga25vd24gZm9yIG15IGxhcmdlLCBoZWFydC1zaGFwZWQgbGVhdmVzIiwKImFuc3dlciI6ICJTeWNhbW9yZSIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHZlZ2V0YWJsZSB0aGF0IGlzIGdyZWVuIGFuZCBvZnRlbiB1c2VkIGluIHNvdXBzIiwKImFuc3dlciI6ICJTcGluYWNoIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgcGxhbnQgdGhhdCBpcyBvZnRlbiB1c2VkIGluIGhlcmJhbCB0ZWFzIGFuZCBrbm93biBmb3IgbXkgZGlnZXN0aXZlIHByb3BlcnRpZXMiLAoiYW5zd2VyIjogIlBlcHBlcm1pbnQiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmcnVpdCB0aGF0IGlzIG9yYW5nZSBhbmQgb2Z0ZW4gYXNzb2NpYXRlZCB3aXRoIHRyb3BpY2FsIHZhY2F0aW9ucyIsCiJhbnN3ZXIiOiAiUGluZWFwcGxlIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgc21hbGwgZWxlY3Ryb25pYyBkZXZpY2UgdXNlZCB0byBrZWVwIHRpbWUiLAoiYW5zd2VyIjogIldhdGNoIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgY3lsaW5kcmljYWwgd3JpdGluZyBpbnN0cnVtZW50IHVzZWQgdG8gYXBwbHkgaW5rIiwKImFuc3dlciI6ICJQZW4iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSB0b29sIHdpdGggYSBzZXJyYXRlZCBibGFkZSB1c2VkIHRvIGN1dCBwYXBlciIsCiJhbnN3ZXIiOiAiU2Npc3NvcnMiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSByZWN0YW5ndWxhciBvYmplY3QgdXNlZCB0byBkaXNwbGF5IGRpZ2l0YWwgaW5mb3JtYXRpb24gYW5kIGltYWdlcyIsCiJhbnN3ZXIiOiAiVGVsZXZpc2lvbiIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHNtYWxsIG1ldGFsIG9iamVjdCB1c2VkIHRvIGZhc3RlbiBwYXBlcnMgdG9nZXRoZXIiLAoiYW5zd2VyIjogIlBhcGVyY2xpcCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHBvcnRhYmxlIGNvbnRhaW5lciB1c2VkIHRvIGNhcnJ5IGJlbG9uZ2luZ3MiLAoiYW5zd2VyIjogIkJhY2twYWNrIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgY3lsaW5kcmljYWwgb2JqZWN0IHVzZWQgdG8gd3JpdGUgb3IgZHJhdyB3aXRoIGdyYXBoaXRlIiwKImFuc3dlciI6ICJQZW5jaWwiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmbGF0LCByZWN0YW5ndWxhciBvYmplY3QgdXNlZCB0byBzdG9yZSBhbmQgb3JnYW5pemUgcGFwZXJzIiwKImFuc3dlciI6ICJGb2xkZXIiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCBlbGVjdHJvbmljIGRldmljZSB1c2VkIHRvIGNvbW11bmljYXRlIHdpdGggb3RoZXJzIiwKImFuc3dlciI6ICJNb2JpbGUgcGhvbmUiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSB0b29sIHdpdGggYSBtZXRhbCBibGFkZSB1c2VkIHRvIGN1dCB0aHJvdWdoIG1hdGVyaWFscyIsCiJhbnN3ZXIiOiAiS25pZmUiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSByZWN0YW5ndWxhciBvYmplY3QgdXNlZCB0byBjYXB0dXJlIGFuZCBkaXNwbGF5IHBob3RvZ3JhcGhzIiwKImFuc3dlciI6ICJDYW1lcmEiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCwgY2lyY3VsYXIgb2JqZWN0IHVzZWQgdG8gZmFzdGVuIGNsb3RoaW5nIiwKImFuc3dlciI6ICJCdXR0b24iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBwb3J0YWJsZSBjb250YWluZXIgdXNlZCB0byBzdG9yZSBhbmQgY2FycnkgZm9vZCBhbmQgYmV2ZXJhZ2VzIiwKImFuc3dlciI6ICJMdW5jaGJveCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGN5bGluZHJpY2FsIG9iamVjdCB1c2VkIHRvIGRyaW5rIGJldmVyYWdlcyIsCiJhbnN3ZXIiOiAiQ3VwIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgc21hbGwgZWxlY3Ryb25pYyBkZXZpY2UgdXNlZCB0byBsaXN0ZW4gdG8gbXVzaWMiLAoiYW5zd2VyIjogIkhlYWRwaG9uZXMiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSByZWN0YW5ndWxhciBvYmplY3QgdXNlZCB0byBjYXB0dXJlIGFuZCBkaXNwbGF5IHdyaXR0ZW4gaW5mb3JtYXRpb24iLAoiYW5zd2VyIjogIk5vdGVib29rIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgc21hbGwgY29udGFpbmVyIHVzZWQgdG8gaG9sZCBsaXF1aWQgY29zbWV0aWNzIiwKImFuc3dlciI6ICJCb3R0bGUiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCwgcmVjdGFuZ3VsYXIgZGV2aWNlIHVzZWQgdG8gbWFrZSBjYWxjdWxhdGlvbnMiLAoiYW5zd2VyIjogIkNhbGN1bGF0b3IiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBjeWxpbmRyaWNhbCBvYmplY3QgdXNlZCB0byB3cml0ZSBvciBkcmF3IHdpdGggaW5rIiwKImFuc3dlciI6ICJNYXJrZXIiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmbGF0LCByZWN0YW5ndWxhciBvYmplY3QgdXNlZCB0byBjb3ZlciBhIHRhYmxlIG9yIHByb3RlY3Qgc3VyZmFjZXMiLAoiYW5zd2VyIjogIlRhYmxlY2xvdGgiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBjeWxpbmRyaWNhbCBvYmplY3QgdXNlZCB0byBhcHBseSBjb2xvciB0byB0aGUgbGlwcyIsCiJhbnN3ZXIiOiAiTGlwc3RpY2siCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBwb3J0YWJsZSBjb250YWluZXIgdXNlZCB0byBzdG9yZSBhbmQgY2FycnkgbW9uZXkgYW5kIGNhcmRzIiwKImFuc3dlciI6ICJXYWxsZXQiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCwgcmVjdGFuZ3VsYXIgb2JqZWN0IHVzZWQgdG8gZmFzdGVuIHBhcGVycyB0b2dldGhlciIsCiJhbnN3ZXIiOiAiQmluZGVyIGNsaXAiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBjeWxpbmRyaWNhbCBvYmplY3QgdXNlZCB0byB3cml0ZSBvciBkcmF3IHdpdGggY29sb3JlZCB3YXgiLAoiYW5zd2VyIjogIkNyYXlvbiIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGZsYXQsIHJlY3Rhbmd1bGFyIG9iamVjdCB1c2VkIHRvIGNsZWFuIG9yIGVyYXNlIHBlbmNpbCBtYXJrcyIsCiJhbnN3ZXIiOiAiRXJhc2VyIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgc21hbGwgZWxlY3Ryb25pYyBkZXZpY2UgdXNlZCB0byBuYXZpZ2F0ZSBhbmQgYWNjZXNzIGluZm9ybWF0aW9uIiwKImFuc3dlciI6ICJUYWJsZXQiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBwb3J0YWJsZSBjb250YWluZXIgdXNlZCB0byBzdG9yZSBhbmQgY2FycnkgcGVyc29uYWwgYmVsb25naW5ncyIsCiJhbnN3ZXIiOiAiSGFuZGJhZyIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHNtYWxsLCByZWN0YW5ndWxhciBvYmplY3QgdXNlZCB0byBzdG9yZSBhbmQgY2FycnkgZGlnaXRhbCBmaWxlcyIsCiJhbnN3ZXIiOiAiVVNCIGZsYXNoIGRyaXZlIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgY3lsaW5kcmljYWwgb2JqZWN0IHVzZWQgdG8gd3JpdGUgb3IgZHJhdyB3aXRoIGluayIsCiJhbnN3ZXIiOiAiQmFsbHBvaW50IHBlbiIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGZsYXQsIHJlY3Rhbmd1bGFyIG9iamVjdCB1c2VkIHRvIGRpc3BsYXkgcHJpbnRlZCBpbWFnZXMiLAoiYW5zd2VyIjogIlBvc3RlciIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHNtYWxsIGVsZWN0cm9uaWMgZGV2aWNlIHVzZWQgdG8gdGFrZSBwaG90b2dyYXBocyIsCiJhbnN3ZXIiOiAiQ2FtZXJhIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgdGFsbCwgd29vZHkgcGVyZW5uaWFsIHBsYW50IHdpdGggeWVsbG93IGZsb3dlcnMiLAoiYW5zd2VyIjogIlN1bmZsb3dlciIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHNtYWxsIGVsZWN0cm9uaWMgZGV2aWNlIHVzZWQgdG8ga2VlcCB0aW1lIiwKImFuc3dlciI6ICJXYXRjaCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGN5bGluZHJpY2FsIHdyaXRpbmcgaW5zdHJ1bWVudCB1c2VkIHRvIGFwcGx5IGluayIsCiJhbnN3ZXIiOiAiUGVuIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgdG9vbCB3aXRoIGEgc2VycmF0ZWQgYmxhZGUgdXNlZCB0byBjdXQgcGFwZXIiLAoiYW5zd2VyIjogIlNjaXNzb3JzIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgcmVjdGFuZ3VsYXIgb2JqZWN0IHVzZWQgdG8gZGlzcGxheSBkaWdpdGFsIGluZm9ybWF0aW9uIGFuZCBpbWFnZXMiLAoiYW5zd2VyIjogIlRlbGV2aXNpb24iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCBtZXRhbCBvYmplY3QgdXNlZCB0byBmYXN0ZW4gcGFwZXJzIHRvZ2V0aGVyIiwKImFuc3dlciI6ICJQYXBlcmNsaXAiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBwb3J0YWJsZSBjb250YWluZXIgdXNlZCB0byBjYXJyeSBiZWxvbmdpbmdzIiwKImFuc3dlciI6ICJCYWNrcGFjayIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGN5bGluZHJpY2FsIG9iamVjdCB1c2VkIHRvIHdyaXRlIG9yIGRyYXcgd2l0aCBncmFwaGl0ZSIsCiJhbnN3ZXIiOiAiUGVuY2lsIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgZmxhdCwgcmVjdGFuZ3VsYXIgb2JqZWN0IHVzZWQgdG8gc3RvcmUgYW5kIG9yZ2FuaXplIHBhcGVycyIsCiJhbnN3ZXIiOiAiRm9sZGVyIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgc21hbGwgZWxlY3Ryb25pYyBkZXZpY2UgdXNlZCB0byBjb21tdW5pY2F0ZSB3aXRoIG90aGVycyIsCiJhbnN3ZXIiOiAiUGhvbmUiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSB0b29sIHdpdGggYSBtZXRhbCBibGFkZSB1c2VkIHRvIGN1dCB0aHJvdWdoIG1hdGVyaWFscyIsCiJhbnN3ZXIiOiAiS25pZmUiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSByZWN0YW5ndWxhciBvYmplY3QgdXNlZCB0byBjYXB0dXJlIGFuZCBkaXNwbGF5IHBob3RvZ3JhcGhzIiwKImFuc3dlciI6ICJDYW1lcmEiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCwgY2lyY3VsYXIgb2JqZWN0IHVzZWQgdG8gZmFzdGVuIGNsb3RoaW5nIiwKImFuc3dlciI6ICJCdXR0b24iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBwb3J0YWJsZSBjb250YWluZXIgdXNlZCB0byBzdG9yZSBhbmQgY2FycnkgZm9vZCBhbmQgYmV2ZXJhZ2VzIiwKImFuc3dlciI6ICJMdW5jaGJveCIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIGN5bGluZHJpY2FsIG9iamVjdCB1c2VkIHRvIGRyaW5rIGJldmVyYWdlcyIsCiJhbnN3ZXIiOiAiQ3VwIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgc21hbGwgZWxlY3Ryb25pYyBkZXZpY2UgdXNlZCB0byBsaXN0ZW4gdG8gbXVzaWMiLAoiYW5zd2VyIjogIkhlYWRwaG9uZXMiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSByZWN0YW5ndWxhciBvYmplY3QgdXNlZCB0byBjYXB0dXJlIGFuZCBkaXNwbGF5IHdyaXR0ZW4gaW5mb3JtYXRpb24iLAoiYW5zd2VyIjogIk5vdGVib29rIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgc21hbGwgY29udGFpbmVyIHVzZWQgdG8gaG9sZCBsaXF1aWQgY29zbWV0aWNzIiwKImFuc3dlciI6ICJCb3R0bGUiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCwgcmVjdGFuZ3VsYXIgZGV2aWNlIHVzZWQgdG8gbWFrZSBjYWxjdWxhdGlvbnMiLAoiYW5zd2VyIjogIkNhbGN1bGF0b3IiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBjeWxpbmRyaWNhbCBvYmplY3QgdXNlZCB0byB3cml0ZSBvciBkcmF3IHdpdGggaW5rIiwKImFuc3dlciI6ICJNYXJrZXIiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmbGF0LCByZWN0YW5ndWxhciBvYmplY3QgdXNlZCB0byBjb3ZlciBhIHRhYmxlIG9yIHByb3RlY3Qgc3VyZmFjZXMiLAoiYW5zd2VyIjogIlRhYmxlY2xvdGgiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCBlbGVjdHJvbmljIGRldmljZSB1c2VkIHRvIHBsYXkgbXVzaWMgYW5kIHZpZGVvcyIsCiJhbnN3ZXIiOiAicGxheWVyIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgY3lsaW5kcmljYWwgb2JqZWN0IHVzZWQgdG8gYXBwbHkgY29sb3IgdG8gdGhlIGxpcHMiLAoiYW5zd2VyIjogIkxpcHN0aWNrIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgcG9ydGFibGUgY29udGFpbmVyIHVzZWQgdG8gc3RvcmUgYW5kIGNhcnJ5IG1vbmV5IGFuZCBjYXJkcyIsCiJhbnN3ZXIiOiAiV2FsbGV0Igp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgc21hbGwsIHJlY3Rhbmd1bGFyIG9iamVjdCB1c2VkIHRvIGZhc3RlbiBwYXBlcnMgdG9nZXRoZXIiLAoiYW5zd2VyIjogIkJpbmRlciBjbGlwIgp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgY3lsaW5kcmljYWwgb2JqZWN0IHVzZWQgdG8gd3JpdGUgb3IgZHJhdyB3aXRoIGNvbG9yZWQgd2F4IiwKImFuc3dlciI6ICJDcmF5b24iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmbGF0LCByZWN0YW5ndWxhciBvYmplY3QgdXNlZCB0byBjbGVhbiBvciBlcmFzZSBwZW5jaWwgbWFya3MiLAoiYW5zd2VyIjogIkVyYXNlciIKfSwKewoicXVlc3Rpb24iOiAiSSBhbSBhIHNtYWxsIGVsZWN0cm9uaWMgZGV2aWNlIHVzZWQgdG8gbmF2aWdhdGUgYW5kIGFjY2VzcyBpbmZvcm1hdGlvbiIsCiJhbnN3ZXIiOiAiVGFibGV0Igp9LAp7CiJxdWVzdGlvbiI6ICJJIGFtIGEgcG9ydGFibGUgY29udGFpbmVyIHVzZWQgdG8gc3RvcmUgYW5kIGNhcnJ5IHBlcnNvbmFsIGJlbG9uZ2luZ3MiLAoiYW5zd2VyIjogIkhhbmRiYWciCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBjeWxpbmRyaWNhbCBvYmplY3QgdXNlZCB0byB3cml0ZSBvciBkcmF3IHdpdGggaW5rIiwKImFuc3dlciI6ICJwZW4iCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBmbGF0LCByZWN0YW5ndWxhciBvYmplY3QgdXNlZCB0byBkaXNwbGF5IHByaW50ZWQgaW1hZ2VzIiwKImFuc3dlciI6ICJQb3N0ZXIiCn0sCnsKInF1ZXN0aW9uIjogIkkgYW0gYSBzbWFsbCwgY2lyY3VsYXIgb2JqZWN0IHVzZWQgdG8gcGxheSBtdXNpYyIsCiJhbnN3ZXIiOiAiQ0QiCn0KXQo=";
const List<String> charList=["Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M"];
String email=Platform.isAndroid?"":"niked@monctonareahomesrealty.com";
String privacy=Platform.isAndroid?"":"https://wordlandwin.com/privacy/";
String adjustToken=Platform.isIOS?"7y1ulm8x6qv4":"";
String maxAdKey=Platform.isIOS?"TVdKemhuRVB0S3F4TEtSTEFsVnJUeVFmTzJWeFdaV3RWeF9TelRXQ19NZ29aTDdrVEtOdDl0M01fT2dJWjI0bkJYUlh4VmQ5b2dRRXA3NjE2VFdmM0M=":"";
String valueConfStr="ewogICAgIndvcmRfcmFuZ2UiOiBbCiAgICAgICAgMzAwLAogICAgICAgIDUwMCwKICAgICAgICA2MDAsCiAgICAgICAgODAwCiAgICBdLAogICAgImNoZWNrX3Jld2FyZCI6IFsKICAgICAgICAyMDAwLAogICAgICAgIDIwMDAsCiAgICAgICAgMzAwMCwKICAgICAgICA1MDAwLAogICAgICAgIDcwMDAsCiAgICAgICAgODAwMCwKICAgICAgICAxMDAwMAogICAgXSwKICAgICJ3b3JkX2NvbnZlcnNpb24iOiAxMDAwMCwKICAgICJyZXdhcmRfd29yZCI6IFsKICAgICAgICB7CiAgICAgICAgICAgICJmaXJzdF9udW1iZXIiOiAwLAogICAgICAgICAgICAid29yZF9yZXdhcmQiOiBbCiAgICAgICAgICAgICAgICAyMDAwMAogICAgICAgICAgICBdLAogICAgICAgICAgICAiZW5kX251bWJlciI6IDIwMDAwCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAgICJmaXJzdF9udW1iZXIiOiAyMDAwMCwKICAgICAgICAgICAgIndvcmRfcmV3YXJkIjogWwogICAgICAgICAgICAgICAgNjAwMDAwCiAgICAgICAgICAgIF0sCiAgICAgICAgICAgICJlbmRfbnVtYmVyIjogNjAwMDAwCiAgICAgICAgfSwKICAgICAgICB7CiAgICAgICAgICAgICJmaXJzdF9udW1iZXIiOiA2MDAwMDAsCiAgICAgICAgICAgICJ3b3JkX3Jld2FyZCI6IFsKICAgICAgICAgICAgICAgIDMwMDAsCiAgICAgICAgICAgICAgICA1MDAwLAogICAgICAgICAgICAgICAgODAwMCwKICAgICAgICAgICAgICAgIDEwMDAwCiAgICAgICAgICAgIF0sCiAgICAgICAgICAgICJlbmRfbnVtYmVyIjogMjAwMDAwMAogICAgICAgIH0sCiAgICAgICAgewogICAgICAgICAgICAiZmlyc3RfbnVtYmVyIjogMjAwMDAwMCwKICAgICAgICAgICAgIndvcmRfcmV3YXJkIjogWwogICAgICAgICAgICAgICAgMTkwMCwKICAgICAgICAgICAgICAgIDE1MDAsCiAgICAgICAgICAgICAgICAxMjAwLAogICAgICAgICAgICAgICAgMjAwMAogICAgICAgICAgICBdLAogICAgICAgICAgICAiZW5kX251bWJlciI6IDI1MDAwMDAKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgImZpcnN0X251bWJlciI6IDI1MDAwMDAsCiAgICAgICAgICAgICJ3b3JkX3Jld2FyZCI6IFsKICAgICAgICAgICAgICAgIDI5MDAsCiAgICAgICAgICAgICAgICA0NTAwLAogICAgICAgICAgICAgICAgMzAwMCwKICAgICAgICAgICAgICAgIDgwMCwKICAgICAgICAgICAgICAgIDkwMAogICAgICAgICAgICBdLAogICAgICAgICAgICAiZW5kX251bWJlciI6IDMwMDAwMDAKICAgICAgICB9CiAgICBdLAogICAgIndoZWVsIjogWwogICAgICAgIHsKICAgICAgICAgICAgImZpcnN0X251bWJlciI6IDAsCiAgICAgICAgICAgICJ3b3JkX3Jld2FyZCI6IFsKICAgICAgICAgICAgICAgIDUwMDAwCiAgICAgICAgICAgIF0sCiAgICAgICAgICAgICJlbmRfbnVtYmVyIjogNTAwMDAKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgImZpcnN0X251bWJlciI6IDUwMDAwLAogICAgICAgICAgICAid29yZF9yZXdhcmQiOiBbCiAgICAgICAgICAgICAgICAzMDAwMAogICAgICAgICAgICBdLAogICAgICAgICAgICAiZW5kX251bWJlciI6IDIwMDAwMDAKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgImZpcnN0X251bWJlciI6IDIwMDAwMDAsCiAgICAgICAgICAgICJ3b3JkX3Jld2FyZCI6IFsKICAgICAgICAgICAgICAgIDE4MDAwCiAgICAgICAgICAgIF0sCiAgICAgICAgICAgICJlbmRfbnVtYmVyIjogMzAwMDAwMAogICAgICAgIH0KICAgIF0sCiAgICAibGV2ZWxfcmV3YXJkIjogWwogICAgICAgIHsKICAgICAgICAgICAgImZpcnN0X251bWJlciI6IDAsCiAgICAgICAgICAgICJ3b3JkX3Jld2FyZCI6IFsKICAgICAgICAgICAgICAgIDQwMDAwLAogICAgICAgICAgICAgICAgMzUwMDAsCiAgICAgICAgICAgICAgICAyMDAwMAogICAgICAgICAgICBdLAogICAgICAgICAgICAiZW5kX251bWJlciI6IDEwMDAwMDAKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgImZpcnN0X251bWJlciI6IDEwMDAwMDAsCiAgICAgICAgICAgICJ3b3JkX3Jld2FyZCI6IFsKICAgICAgICAgICAgICAgIDEwMDAwLAogICAgICAgICAgICAgICAgMTIwMDAsCiAgICAgICAgICAgICAgICAxNTAwMAogICAgICAgICAgICBdLAogICAgICAgICAgICAiZW5kX251bWJlciI6IDIwMDAwMDAKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICAgImZpcnN0X251bWJlciI6IDIwMDAwMDAsCiAgICAgICAgICAgICJ3b3JkX3Jld2FyZCI6IFsKICAgICAgICAgICAgICAgIDkwMDAsCiAgICAgICAgICAgICAgICA1MDAwLAogICAgICAgICAgICAgICAgMjAwMAogICAgICAgICAgICBdLAogICAgICAgICAgICAiZW5kX251bWJlciI6IDMwMDAwMDAKICAgICAgICB9CiAgICBdCn0=";
String maxAdStr=Platform.isIOS? "ewogICJ4aGZoZW5udCI6IDEwMCwKICAibnhzY3ZiYnciOiAxMDAsCiAgIndwZG5kX2xhdW5jaF9vbmUiOiBbCiAgICB7CiAgICAgICJwb3hnaHRtbiI6ICJjMzQ1ZWFiN2ZiNDQxNzEyIiwKICAgICAgInhjd3B3Z2R4IjogIm1heCIsCiAgICAgICJxZWJtbmJ4dCI6ICJpbnRlcnN0aXRpYWwiLAogICAgICAid2Rzc2h6aGQiOiAzMDAwLAogICAgICAibW9ldHFxZmEiOiAzCiAgICAgfQogIF0sCiAgIndwZG5kX2xhdW5jaF90d28iOiBbCiAgICB7CiAgICAgICJwb3hnaHRtbiI6ICJiOWEzMTEwYzQxYjI0MWM5IiwKICAgICAgInhjd3B3Z2R4IjogIm1heCIsCiAgICAgICJxZWJtbmJ4dCI6ICJpbnRlcnN0aXRpYWwiLAogICAgICAid2Rzc2h6aGQiOiAzMDAwLAogICAgICAibW9ldHFxZmEiOiAzCiAgICAgfQogIF0sCiAgIndwZG5kX3J2X29uZSI6IFsKICAgICB7CiAgICAgICJwb3hnaHRtbiI6ICJhYTQwYzA2YjFjYzdjODkwIiwKICAgICAgInhjd3B3Z2R4IjogIm1heCIsCiAgICAgICJxZWJtbmJ4dCI6ICJyZXdhcmQiLAogICAgICAid2Rzc2h6aGQiOiAzMDAwLAogICAgICAibW9ldHFxZmEiOiAzCiAgICAgfQogIF0sCiAgIndwZG5kX3J2X3R3byI6IFsKICAgICB7CiAgICAgICJwb3hnaHRtbiI6ICI0M2Y2MDRkNWMwZTAyNjYzIiwKICAgICAgInhjd3B3Z2R4IjogIm1heCIsCiAgICAgICJxZWJtbmJ4dCI6ICJyZXdhcmQiLAogICAgICAid2Rzc2h6aGQiOiAzMDAwLAogICAgICAibW9ldHFxZmEiOiAzCiAgICAgfQogIF0sCiAgIndwZG5kX2ludF9vbmUiOiBbCiAgICB7CiAgICAgICJwb3hnaHRtbiI6ICJiNTkwYmM0YWRlZThjYzU2IiwKICAgICAgInhjd3B3Z2R4IjogIm1heCIsCiAgICAgICJxZWJtbmJ4dCI6ICJpbnRlcnN0aXRpYWwiLAogICAgICAid2Rzc2h6aGQiOiAzMDAwLAogICAgICAibW9ldHFxZmEiOiAzCiAgICAgIH0KICBdLAogICJ3cGRuZF9pbnRfdHdvIjogWwogICAgIHsKICAgICAgInBveGdodG1uIjogImY4OTFkMDQzMWIzNTE1YzYiLAogICAgICAieGN3cHdnZHgiOiAibWF4IiwKICAgICAgInFlYm1uYnh0IjogImludGVyc3RpdGlhbCIsCiAgICAgICJ3ZHNzaHpoZCI6IDMwMDAsCiAgICAgICJtb2V0cXFmYSI6IDMKICAgIH0KICBdCn0=":"";
String tbaPath=Platform.isIOS?"https://carnage.wordlandwin.com/whale/barry":"";








