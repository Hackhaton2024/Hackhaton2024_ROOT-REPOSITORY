# Conventions pour le projet Hackathon :

@author T.NGUYEN

---

## Convention de nommage

### Casses

On a les casses suivantes :

- Nom de classe en *Pascal case* : `MyFirstClass` ;
- Nom de variable en *camel case* : `numberOfProcess` ;
- Nom de méthode en *camel case* : `createUser()` ;
- Nom de constante en *upper snake case*: `MAX_USER_NBR` ;
- Nom de *package* ou de module en *kebab case* : `my-first-package`.

### Nommages

Une méthode correspond à un groupe verbal.

Une variable booléenne correspond à un groupe verbal d’état : `isActivated`, `canBeDestroyed` etc.

Toute autre variable correspond un groupe nominal.

Une interface correspond à une capacité ou un groupe adjectival : `Colorizable`, `AbleToDie` etc.

## Git

### Stratégie d’organisation des *commits* sur la branche principale

La branche `main` va contenir le code opérationnel du projet.
Dans l’optique de maintenir un historique clair et aisément navigable, la stratégie d’organisation des *commits* et d’intégration de code au dépôt distant suit deux cas.

Lorsqu’**une branche correspond à une étape clé** d’un projet (fonctionnalité, *user story*…) qui nécessite une **visibilité immédiate dans l’historique**, son intégration dans la branche `main` se fera à l’aide de la commande `git merge`.
Ceci aura l’effet de mettre en évidence cet apport sous la forme d’une ***bosse*** aisément identifiable. 
**La branche sera alors concervée** après son intégration.

Lorsqu’une branche de code **n’existe que pour une raison purement technique**, une *bosse* polluerait  visuellement : le code sera donc intégré à l’aide de la commande `git rebase`.
**La branche est supprimée** une fois intégrée.

![merge-rebase](./readme_img/merge_rebase.png)

L’organisation de code partagé, avec Git et Github, s’avère être une partie sensible qui peut rapidement devenir *incontrôlable*.
Nous nous imposerons pour minimiser les problèmes les règles suivantes :

- **Un seul développeur sur une branche** ;

- Il n’y a que lors des requêtes de tirage en fin de journée que les *commits* de différents contributeurs se côtoient sur une même branche ;

- Le code à intégrer à la branche principale se fait toujours par l’intermédiaire d’une requête de tirage (pull request)

- Le code doit toujours être révisé ;

- Le code **ne fusionne jamais** vers la branche principale **par son auteur** ;

- Le contributeur **qui fusionne** le code doit l’avoir **révisé avant** ;

- Le code sera intégré sur la branche principale directement depuis Github, c’est à cette occasion que la stratégie de fusion ou de rebasage sera à réfléchir ;

  

##### 3. Exemple de pull request

##### Sangoku fait une demande d’intégration de son code à la branche principale **en ouvrant une requête de tirage sur Github**.

![Graphe de Git 2](./readme_img/gitGraph_2a.png)

Pour finir, après avoir cliqué sur le bouton *Create pull request*, **il assigne sa requête de tirage à la colonne *Pull request review*** du projet.

![Graphe de Git 3](./readme_img/gitGraph_2b.png)

Quand toutes les requêtes de tirage de la journée sont ouvertes on peut imaginer qu’un troisième contributeur se rend sur le **kanban du projet**.
Il voit deux requêtes de tirage à traiter comme le graphe ci-dessous.

![Graphe de Git 4](./readme_img/gitGraph_3a.png)

##### 6. Revue de code léger

Il commence par traiter le travail de Sangoku.
Cette branche est uniquement technique.
Ainsi, après avoir révisé le code, il le valide et l’intègre à la branche `main` avec un **rebasage**.

Il n’y aura pas de *bosse* qui polluera l’historique de la branche principale, mais une trace de chaque *commit* de Sangoku sera gardée.

![Graphe de Git 5](./readme_img/gitGraph_3b.png)

##### 7. Revue de code lourd

Il traite ensuite le travail de Krilin.
Le travail de ce dernier est une étape importante qui doit être à ce titre être visuellement explicite dans l’historique.
Il révise et valide le code puis le rapatrie en effectuant une **fusion** vers `main`.
Ceci donne lieu à l’apparition d’un **nouveau *commit*** sur la branche `main`.

![Graphe de Git 6](./readme_img/gitGraph_3c.png)

*Nota bene* : On peut constater que le statut des requêtes de tirage passe **automatiquement à *Done*** dans le kanban après l’opération.

![Graphe de Git 7](./readme_img/gitGraph_3d.png)


## Serveur frontal (Angular)

### Stratégie de génération de composants

Les règles de gestion des composants retenues sont les suivantes:

- **Absence de fichier vide**
- **L'application d'un style css ou l'association d'un template html donne lieu à l'apparition d'un fichier dédié, *quelque soit le nombre de ligne de code qu'il contiendra*.**

Dans cette optique, la stratégie par défaut de génération de composant donnera lieu à l'apparition de 2 fichiers:

- Un fichier ts
- Son spec.ts associéè 

### Échanges HTTP

Le serveur Angular initiera les requêtes HTTP à l’aide du service `HttpClient` d’Angular qui sera injecté via le constructeur de la classe.
Ce dernier est activé dans l’application au niveau **global** :
`HttpClientModule` est en conséquence importé depuis le module racine dans `src/app/app.module.ts`.

#### Envoi d’une requête

Le lancement d’une requête HTTP se fera au sein d’une méthode dans un **service dédié**.

Pour cette méthode, si l’envoi de données est requis, ces données seront transmises sous forme de **DTO en paramètres de méthode**.
Le DTO sera *sérialisé* en **objet JSON** via la méthode `JSON.stringify`.
Ceci devra être signalé spécifiquement dans l’en-tête de la requête HTTP, soit `{ "content-type": "application/json" }`.

Cette méthode renverra un **observable** dont le type générique sera `HttpResponse<DataInBodyType>`.
Elle évoquera aussi `HttpClient` avec l’option `observe` afin de pouvoir accéder à la réponse complète (*body*, *headers*, *status code*…).

Par défaut le client HTTP d’Angular s’attend à recevoir un objet JSON si une donnée est présente dans le corps de la réponse.
Dans le cas où le contenu est de type `plain/text` (la réponse contient une chaîne de caractères) il est impératif de le préciser dans la méthode avec l’option `responseType: 'text'`.
Autrement une erreur de formattage (*parsing*) de la réponse apparaîtra.

Si la requête HTTP nécessite une authentification elle sera de la forme suivante :
```typescript
const headers = { 'Authorization': `Bearer ${bearer}` };
```

*Nota bene* : le *bearer* est le JWT reçu lors de la connexion au service.

#### Exploitation de la méthode d’envoi de requête et de la réponse reçue

L’envoi de la requête (l’appel au service) nécessite de *souscrire à l’observable qu’elle est censée renvoyer*.
Cette souscription implémentera obligatoirement :
  - La gestion de la réponse ;
  - La gestion d’une erreur éventuelle.

  Exemple :
  ```typescript
  onSubmitRegister() {
  // Dto creation if needed
  this.registerRequestBody = {
    pseudo: this.pseudonyme,
    username: this.username,
    password: this.password,
  };
  
  this.publicUserService.addUser(this.registerRequestBody).subscribe(
    // Response case
    (response) => {
      // get response status
      this.registerResponseStatus = response.status;
      // get response body
      this.registerResponseBody = response.body;
  
      // Response treatement
      if (
        this.registerResponseStatus === 201 &&
        this.registerResponseBody !== null
      ) {
        this.registerResponseMsgToDisplay = response.body;
        this.registering_success = true;
      } else {
        throw new Error("HTTP Response body is empty");
      }
    },
  
    // Error case
    (error) => {
      this.registerResponseStatus = error.status;
      this.registerResponseMsgToDisplay = error.error.msg;
      return throwError(error);
    }
  );
  }
  ```

  On peut également utiliser `catchError()` de RxJS :
  ```typescript
  OnSubmit() {
  const signInRequestDto: SignInRequestDto = {
    username: this.email,
    password: this.password,
  };
  
  this.publicUserservice
    .loginUser(signInRequestDto)
    .pipe(
      catchError((error) => {
        this.changePasswordResponseStatus = error.status;
        this.changePasswordResponseBody = error.error.detail;
        return throwError(error);
      })
    )
    .subscribe((response) => {
      this.changePasswordResponseStatus = response.status;
      if (response.status === 200 && response.body !== null) {
        this.signInResponseDto = response.body;
        this.tokenService.saveToken(this.signInResponseDto.bearer);
        this.router.navigate(["dashboard"]);
      }
    });
  }
  ```

### *Data Transfert Objects*

#### Nommage

Les DTO prendront la forme d’interfaces (types) aux propriétés immuables.
Dans un soucis de clarté, ils adopterons les noms tels qu’ils sont écrits dans le corps de requête en JSON par le serveur dorsal.

Soit `MySubject` le sujet, le DTO de requête du serveur frontal sera `MySubjectRequestDto`.
L’homologue de réponse du serveur dorsal sera `MySubjectResponseDto`.

Exemple de `register-request.dto.ts`, côté frontal :
```typescript
export type RegisterRequestDto = {
    readonly pseudo: string;
    readonly username: string;
    readonly password: string;
}
```

Dans `RegisterRequestDto.java`, côté dorsal :
```java
public record RegisterRequestDto(
    String pseudo,
    String username) {}
```

#### Initialisation

Le DTO devra en conséquence *s’initialiser à la volée* :
```typescript
onSubmitRegister() {
    // Dto creation if needed
    this.registerRequestBody = {
      pseudo: this.pseudonyme,
      username: this.username,
      password: this.password,
    };
  /*...*/
}
```

#### Sérialisation et désérialisation

Pour pouvoir être envoyé sur le réseau, le DTO doit être *sérialisé* en un objet JSON.
Nous utiliserons pour cela la méthode `JSON.stringify` :
```typescript
serializedUserToRegister: string = JSON.stringify(userToRegister);
```

Pour pouvoir être exploité après réception, l’objet JSON doit être désérialisé.
Nous utiliserons pour cela la méthode `JSON.parse`.
```typescript
// Objet JSON reçu
const JSON_STRING: string =
'{"name": "Tenshinan", "username": "tenshinan@kame-house.com", "password":"ch@ozu!78P"}';

// Reconstruction de l'objet exploitable
const deserializedUser: PublicUserDtoRequest = JSON.parse(JSON_STRING);

console.log(deserializedUser.username);
```

### Classes TypeScript

#### Instanciation des objets

Hormis de très rares cas, les constructeurs des classes TypeScript dans Angular doivent **rester vides**.
Il ne serviront la plupart du temps qu’à **injecter les dépendances.**

Toute **initialisation d’attribut** s’effectuera dans la méthode Angular dédiée à cet effet : `ngOnInit`.

## Serveur dorsal (Spring Boot)

### Gestion des échanges HTTP par les *REST controllers*

#### Conventions pour les *REST controllers*

Les classes responsables des échanges avec le serveur dorsal seront annotées par `@RestController`.
Cette annotation est spécialement désignée pour les API REST qui manipulent des données HTTP.
Ainsi :
- Le contrôleur retourne directement des données, automatiquement sérialisées dans le format choisi et envoyé dans le corps de la réponse ;
- L’annotation `@ResponseBody` n’est plus nécessaire.

Les contrôleurs :
- Renverront *status*, *body* et — le cas échéant — *headers* pour une possibilité d’exploitation maximale côté Angular ;
- Retourneront `ResponseEntity<typeReturnedData>` à fin de laisser la possibilité d’une exploitation complète de la réponse côté Angular.

Le nom du contrôleur respectera la forme :  `<TypeExceptionManaged>Handler`.
Si le contrôleur doit recevoir une donnée un DTO dédié annoté `@RequestBody` sera intégré en tant que paramètre de la méthode.

Exemple :
```java
@Slf4j // For output errors in console
@RestControllerAdvice	// Exception Centralized manager
public class ApplicationControllerAdvice {

/**
 * Create user account
 * 
 * @param userDto   Attempted type of data (@ResponseBody is not necessary because using @RestController)
 * @return ResponseEntity<String> Response entity (http gestion facilities) that contains type of data in response body
 * @throws InoteExistingEmailException
 * @throws InoteInvalidEmailException
 * @throws InoteRoleNotFoundException
 * @throws InoteInvalidPasswordFormatException
 * 
 * @author atsuhikoMochizuki
 * @date 19/05/2024
 */

@PostMapping(path = Endpoint.REGISTER)  // HTTP method + Endpoint
public ResponseEntity<String> register(/*@RequestBody*/ UserDto userDto) { 
    User userToRegister = User.builder()
            .email(userDto.username())
            .name(userDto.name())
            .password(userDto.password())
            .build();
    try {
        this.userService.register(userToRegister);
    } catch (InoteMailException | InoteExistingEmailException | InoteInvalidEmailException
            | InoteRoleNotFoundException
            | InoteInvalidPasswordFormatException ex) {

        return ResponseEntity
            // Status code
            .badRequest()
            //body response
            .body(ex.getMessage());
    }

    return ResponseEntity
        // status code
        .status(HttpStatusCode.valueOf(201))
        // body response
        .body(MessagesEn.ACTIVATION_NEED_ACTIVATION);
}
```

#### Modèle d’implémentation des exceptions

Les exceptions seront placées dans la couche crossCutting/exceptions. 
Le message associé fera référence à une constante définie dans la classe MessageEn.

```java
public class InoteInvalidEmailFormat extends Exception{
    public InoteInvalidEmailFormat(){
        super(EMAIL_ERROR_INVALID_EMAIL_FORMAT);
    }
}
```

#### Centralisation des exceptions attrapées dans les controllers REST

La gestion des exceptions attrapées dans les RestControllers de l’api sera sera centralisée dans la classe ApplicationControllerAdvice. 

Voilà comment procéder lorsque l’on souhaite ajouter une exception:

1. On crée l’exception dans la couche crossCutting/exceptions

   *exemple InoteInvalidEmailException.java:*

```java
public class InoteInvalidEmailException extends Exception {
    public InoteInvalidEmailException(){
        super(EMAIL_ERROR_INVALID_EMAIL_FORMAT);
    }
}
```

2. On rajoute ensuite cette exception dans ApplicationControllerAdvice. 
   On y précisera, à l’aide de la classe ProbemDetail

   - Le status code à renvoyer
   - Le message à afficher, qui devra être celui de l’exception
     *exemple:*

   ```java
   @Slf4j	// For output errors in console
   @RestControllerAdvice // Handle exceptions in a centralized way for all controllers 
   public class ApplicationControllerAdvice {
   
       @ExceptionHandler(value = InoteInvalidEmailException.class)
   	public ProblemDetail InoteInvalidEmailException(InoteInvalidEmailException ex) {
   	// Loging error in console
       log.error(ex.getMessage(), ex);
   	
       return ProblemDetail
           .forStatusAndDetail(
               // return status code
               BAD_REQUEST,
               // return reason
               ex.getMessage());
   	}
   }
   ```

Nota : si aucune exception ne correspond à une de celles présente dans la couche crossCutting/exception, l’exception par défaut inoteDefaultExceptionsHandler est appelée:

```java
/**
 * Default exception handler
 * 
 * @param ex Default type exception
 * @return a 401 status code with exception cause
 * @author atsuhikoMochizuki
 * @date 19-05-2024
 */
@ExceptionHandler(value = Exception.class)
public ProblemDetail inoteDefaultExceptionHandler(Exception ex) {

    // Loging error in console
    log.error(ex.getMessage(), ex);

    return ProblemDetail
            .forStatusAndDetail(
                    // return status code
                    BAD_REQUEST,
                    // return reason
                    ex.getMessage());
}
```

Nota : Spring boot propose certaines annotations permettant de simplifier :

```java
@ResponseStatus(value = HttpStatus.BAD_REQUEST, reason = "Received Invalid Input Parameters")
    @ExceptionHandler(InputValidationException.class)
    public void handleException(InputValidationException e) {
        // Handle the exception and return a custom error response
    }
```

Nous ne l’utilisons pas dans la plupart des cas car nous souhaitons récupérer la cause de l’exception générée.

#### Sérialisation / Dé-sérialisation des objets JSON

La classe ObjectMapper sera utilisée à cette effet.

- Sérialisation d’un donnée au format JSON

  ```java
  ObjectMapper mapper = new ObjectMapper();
  Map<String, String> map = new HashMap<>();
  map.put("key1", "value1");
  map.put("key2", "value2");
  
  String jsonString = mapper.writeValueAsString(map);
  ```

  A noter que dans le cas précis des controllers, qui sont annotés par @RestController, les données en retournées au front sont automatiquement sérialisées:

  ```java
  @PostMapping(path = Endpoint.SIGN_IN)
  public ResponseEntity<SignInDtoresponse> signIn(@RequestBody AuthenticationDtoRequest authenticationDtorequest) throws AuthenticationException{
  	/* ... */
      return ResponseEntity
              .status(OK)
              .body(signInDtoresponse);
  }
  ```

  

- Désérialisation d’un objet JSON
  soit l’objet JSON sérialisé  récupéré lors d’un test:
  *returnedResponse = response.andReturn().getResponse().getContentAsString();*

  ```java
  {
      "bearer":"fjsdlfjsljfl",
      "refresh":"jkdshfjkhdskfhksfhk"
  }
  ```

  Pour retrouver l’objet Java à l’aide de ObjectMapper:

  ```java
  SignInDtoresponse signInDtoresponse = this.objectMapper.readValue(returnedResponse, SignInDtoresponse.class);
  ```

  A noter que pour les objets sérialisés en provenance du frontend, fournis en paramètres d’un controller, il suffira d’utiliser l’annotation @RequestBody pour désérialiser la donnée:

  ```java
  @PostMapping(path = Endpoint.SIGN_IN)
  public ResponseEntity<SignInDtoresponse> signIn(@RequestBody AuthenticationDtoRequest authenticationDtorequest) throws AuthenticationException{ /*...*/ }
  ```

  

### Javadoc

#### Méthodes

```java
/**
* Save validation in database
*
* @param user the user to save
* @author atsuhiko Mochizuki
* @throws InoteMailException 
* @throws MailException 
* @date 2024-03-26
*/
Validation createAndSave(User user) throws InoteInvalidEmailException, MailException, InoteMailException;
```

### Entités

Hormis le fait de ne pas implémenter obligatoirement `Serializable` les entités respecteront la forme Javabean :

  - La classe est simple et ne fait référence à aucun cadriciel particulier ;
  - La classe ne doit pas être déclarée `final` ;
  - La classe contient une variable `id` annotée `@Id` de type non-primitif `Integer` ;
  - Les propriétés sont privées et exposées par des accesseurs et mutateurs via `@Data` ;
  - La présence d'un constructeur sans arguments annote `@NoArgsConstructor` la classe ;
  - *La classe est sérialisable alors elle doit implémenter `Serializable`* ;
  - La classe qui implémente les surcharges des méthodes `equals()` et `hashCode()` doit être annotée `@Data`.

  On obtient alors ceci :

  ```java
@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor 
@Entity
@Table(name="user") // Si "user" est un mot réservé, pose problèmes que @Table résoud implicitement.
public class User{
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Integer id;
}
  ```

### *Data Transfert Objects*

Les DTO sont des registres Java suffixés comme ci-dessous :

```java
public record CommentDtoResponse(
        Integer id,
        String message,
        Integer UserId
) {}
```

Le suffixe peut être `DtoRequest` pour une donnée de requête reçue ou `DtoResponse` pour une donnée de réponse émise.

### Services

Pour un couplage minimal avec les contrôles, les services exposeront une interface.

Le service est suffixé par `Service`.

L’interface porte le nom de son service suffixé par `Impl`.

### Test

Une classe de test unitaire est suffixée par `Test` : `<classeTestee>Test`.

Une classe de test d’intégration est suffixée `_IT` : `<classeTestee>_IT`.

Un méthode de test unitaire est nommée selon la forme des trois A : *Arrange*, *Act* et *Assert* comme ci-dessous :
```<nomFonction>__<resultatAttendu>__when<condition>```.

Elle devra être annotée `@DisplayName`.
Exemple :

```java
@Test
@DisplayName("Load an user registered in db with username")
public void loadUserByUsername_shouldReturnUser_whenUserNameIsPresent() {
  /* Arrange */
  when(this.userRepository.findByEmail(this.userRef.getUsername())).thenReturn(Optional.of(this.userRef));

  /* Act & assert */
  assertThat(this.userService.loadUserByUsername(this.userRef.getUsername())).isNotNull();
  assertThat(this.userService.loadUserByUsername(this.userRef.getUsername())).isInstanceOf(User.class);
  assertThat(this.userService.loadUserByUsername(this.userRef.getUsername())).isEqualTo(this.userRef);

  /* Verify */
  verify(this.userRepository, times(3)).findByEmail(any(String.class));
}
```
