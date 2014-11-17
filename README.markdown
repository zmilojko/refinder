# Refineder

## Search phylosphy

1.  We search for products, that is the point.

2.  Product belongs to one or more groups, each group might be a top level, or
    belong to one or more supergroups, it is their subgroup. 
   
3.  There is more than one top level group.

4.  Groups can be fuzzy (see categories bellow) or strict (see car models
    bellow). In general, user will allways want to select exactly one (or exactly two or three
    but he is confidently how many and which) strict categories, but will be more insecure about 
    which fuzzy categories to select.
    
### Search phylosophy applied to car part demo

Although not all of these are defined, we have the following two group hieararchies:

1.  We have group hierarchy called categories, on top level is abstract root CATEGORIES, and
    bellow that is a hierarchy of categories (though some can exist in multiple places).  
    In case of categories, each category is shown independently of its supercategories, and
    while selecting a subcategory removes supercategory from selection, supercategory's
    child are shown in the tips section. So since this is recursive, when you select
    a leaf category, you will see the full hieararchy above you as open in the tips.
2.  We have group hiearachy of car models, so MANUFACTURERS abstract group that contains all
    manufacturers is the top level group, and each manufacturer (such as Opel) is a second level group and car model (such as Astra) is a third level group. Bellow that could be sub models
    such as Astra G or simply G, and a year of manufacturing.  
    In case of car models hierarchy, we always show full path, so the group name on the leaf
    is for instance "Opel Astra G 1999 1.6L", and that is all show in one box.

## Showing
    
### Showing criteria

First and farmost, there is the text criteria which is always shown. Later, as some keywords turn
into boxes in the search input, those words might be removed, but as long as boxes are shown outside the input, text should not change.

Selected groups are shown above the input.

### Showing tips

1.  For strict groups

    When a user selects a strict group, only that group's subgroups are shown amongh the tips
    in the tips section named after the selected groups. If I select Astra, it will offer me
    "F", "G" etc in the group called "Opel Astra".

2.  For fuzzy groups

    When user has not selected anything yet, but has focused on the search input, top level
    fuzzy groups are shown. They are always shown, on the bottom of the tips area. When user has selected a fuzzy group, a selection for each level of supergroups is shown up to the top level
    but indented.

### Showing results

I think results are best shown in a separate place! In the end, user can click on a result and go to that page.

Note that at any time we should update the URL so it is bookmarkable.
