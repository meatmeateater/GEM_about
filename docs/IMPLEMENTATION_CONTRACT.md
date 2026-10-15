# Implementation contract — iOS 27 / Swift 5

Root owns models, store, home, shared components and existing tour files. Other agents own only assigned files.

## Content schema

Content/gem-catalog.json: {schemaVersion:1,updatedAt:"2026-10-15",entries:[GEMEntry],sources:[GEMSource]}.

GEMEntry required: id:String, kind:event|release|track|program|stage, title:String, subtitle:String, date:{year:Int,month?:Int,day?:Int}, category:String, summary:String, paragraphs:[String], editorial:String, tags:[String],relatedIDs:[String],sourceIDs:[String]. Optional imageAsset:String,artworkURL:String,metadata:[{label,value}],tracks:[{number:Int,title:String,entryID?:String}],versions:[{id,title,date:GEMDate,releaseID?:String,note,links:[GEMLink],sourceIDs:[String]}],links:[GEMLink]. Optional arrays default empty. All related IDs must resolve.

GEMLink:{label:String,url:String}; computed destination:URL? accepts HTTPS hosts.

GEMSource:{id,title,publisher,url,verifiedAt,scope}, all strings, computed destination:URL?.

Content/media-credits.json: flat array [{id:String,assetName:String,title:String,author:String,sourceURL:String,license:String,licenseURL:String,modifications:String}]. Photo asset names gem_portrait and gem_live. Root displays credits. Keep original JPEG pixels and attribution.

## Swift model API

GEMEntryKind:String,Codable,CaseIterable,Identifiable: .event,.release,.track,.program,.stage; title:String, symbol:String.

GEMDate:Codable,Hashable: year:Int,month:Int?,day:Int?,displayText:String,sortKey:Int,decade:Int.

GEMEntry:Codable,Identifiable,Hashable: JSON fields above; computed year:Int,dateLabel:String,searchText:String.

GEMMetadata:Codable,Hashable,Identifiable: label,value,id.

GEMTrackListing:Codable,Hashable,Identifiable: number:Int,title:String,entryID:String?,id:Int.

GEMRecordingVersion:Codable,Hashable,Identifiable: fields above.

GEMCatalog:Codable: schemaVersion:Int,updatedAt:String,entries:[GEMEntry],sources:[GEMSource]; static empty, static load(bundle:Bundle = .main)throws->GEMCatalog; validate()throws.

## Shared store

@MainActor final class GEMLibrary:ObservableObject. init(catalog:GEMCatalog? = nil,defaults:UserDefaults = .standard,favoritesKey:String = "gem.favorites.v2",bundle:Bundle = .main).

Read-only catalog:GEMCatalog,loadError:String?,favoriteIDs:Set<String>,favoriteEntries:[GEMEntry],mediaCredits:[GEMMediaCredit].

Methods: entry(id:String)->GEMEntry?, entries(of:GEMEntryKind)->[GEMEntry] (newest first), search(query:String,kind:GEMEntryKind? = nil)->[GEMEntry],filteredEvents(category:String? = nil,era:Int? = nil)->[GEMEntry] (oldest first, era = decade, e.g.2010),source(id:String)->GEMSource?,isFavorite(_ id:String)->Bool,toggleFavorite(_ id:String).

GEMRoute:Hashable: .timeline,.library(GEMEntryKind),.search,.favorites,.entry(String),.sources. Root registers destinations. Inner screens must not create another NavigationStack. @EnvironmentObject private var library:GEMLibrary.

## Shared UI root supplies

- GEMEntryRow(entry:GEMEntry): presentation only; caller wraps NavigationLink; no favorite inside.
- GEMArtwork(entry:GEMEntry): square art, local/remote/fallback, caller sets frame.
- GEMFavoriteButton(id:String): independent control; persisted state and accessible value; Reduce Motion.
- GEMFilterChip(title:String,isSelected:Bool,action:@escaping ()->Void).
- GEMEmptyState(title:String,message:String,symbol:String).
- GEMSourceList(sourceIDs:[String]).
- GEMExternalLink(link:GEMLink).
- GEMScreenBackground:View using colorScheme and ignoresSafeArea.
- GEMSectionHeading(eyebrow:String,title:String,description:String).
- existing GEMFont.display/headline/body and GEMPalette.foreground(for:)/secondary(for:)/card(for:)/purple/violet/gold.

UI agent supplies GEMTimelineView(), GEMLibraryView(initialKind:GEMEntryKind = .release),GEMSearchView(),GEMFavoritesView(),GEMDetailView(id:String). Root supplies GEMSourcesView(). Date/category selection state remains in screen. IDs, not full models, in navigation path. No fake playback, empty buttons or nested buttons. User updated the deployment requirement to iOS 27; use the iOS 27 SDK. Apply native swipeActionsContainer in Favorites, textSelection in detail, cached AsyncImage and native glass controls where appropriate. New APIs must be checked against Apple documentation.
