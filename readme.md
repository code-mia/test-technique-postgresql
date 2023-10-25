# Test technique - PostgreSQL

## Tâches :
- [x] Créer un repository publique sur GitHub
- [x] Créer une vue score qui donne un score à chaque ligne de la table crawl en fonction de la longueur du contenu html comparé à la distribution de cette colonne
- [ ] Ecrire une fonction recherche('mot-clé') qui retourne le top dix des documents avec le plus haut score contenant le mot-clé

## Questions

### Que contiennent les tables dans les schéma louis_v005? Expliquer la structure relationelle et la fonction de chaque table.
Voici le diagramme de la structure relationnelle des tables du schéma louis_v005 :
![ERDiagram](bd.png)
En analysant le structure, on peut voir que la table `crawl` contient les informations de base de chaque page web, comme l'url, le titre etc.
La table `html_content` contient le contenu html de chaque page web. 
La table `script` contient les scripts de chaque page web.
La table `link` contient les liens de chaque page web.
La table `chunk` fait référence à un morceau du contenu d'une page web

D'abord, on peut voir qu'il y'a une relation de dépendance entre la table `link` et `crawl`, `link` contient un "source_crawl" et une "destination_crawl" ce qui signifie que chaque lien a une page web source et une page web de destination.

Ensuite, on peut voir qu'il y'a une relation de dépendance entre la table `html_content` et `html_content_to_chunk` mais également entre `html_content_to_chunk` et `chunk`. Cela signifie que chaque contenu hashé  dans la table `html_content` est associé à un ou plusieurs morceaux de contenu dans la table `chunk`.

### Quelle distribution prennent les valeurs de longueur du contenu?

### Expliquer le calcul en fonction de la distribution spécifique des valeurs de longueurs de html_content script

J'utillise la fonction PERCENT_RANK() pour calculer le score de chaque page web. La fonction PERCENT_RANK() permet de calculer le rang d'une ligne dans un ensemble de données par rapport au nombre total de lignes. Elle attribue une valeur entre 0 et 1, où 0 représente la première ligne (plus basse) et 1 représente la dernière ligne (plus haute) dans le classement. 

Dans ce cas la fonction PERCENT_RANK() st calculée comme suit :

```sql
CREATE OR REPLACE VIEW "mia.ben-redjeb.1@ens.etsmtl.ca"."score" as 
SELECT
    c.id AS crawl_id,
    PERCENT_RANK() OVER (ORDER BY LENGTH(h.content)) AS score
FROM louis_v005.crawl c
JOIN louis_v005.html_content h ON c.md5hash = h.md5hash;
```

Ici PERCENT_RANK() est utilisée pour calculer le pourcentage de rang en fonction de la longueur du contenu HTML stocké dans la colonne "content" de la table `louis_v005.html_content`. Les données sont triées par ordre croissant de la longueur du contenu (LENGTH(h.content)), de sorte que les rangs les plus bas seront attribués aux contenus les plus courts, et les rangs les plus élevés aux contenus les plus longs.

### Expliquer et discuter de la performance de votre fonction recherche

