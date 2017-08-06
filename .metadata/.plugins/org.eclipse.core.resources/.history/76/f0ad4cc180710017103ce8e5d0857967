<%--
  ADOBE CONFIDENTIAL
  __________________

   Copyright 2012 Adobe Systems Incorporated
   All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.
--%><%
%><%@include file="/apps/geometrixx-media/global.jsp" %><%
%><%@page session="false" import="com.day.cq.wcm.api.WCMMode,
                                org.apache.sling.settings.SlingSettingsService"%>
<cq:includeClientLib categories="apps.geometrixx-media.profile"/>
<%
    boolean isAuthorMode = WCMMode.fromRequest(request) != WCMMode.DISABLED && !sling.getService(SlingSettingsService.class).getRunModes().contains("publish");
%>
<div class="profile-self">
    <%--<cq:include path="start" resourceType="foundation/components/form/start"/>
    <cq:include script="4x8col.jsp"/>
    <cq:include path="end" resourceType="foundation/components/form/end"/>--%>

	<div class="community-header">
		<div class="category-title">
			<nav class="breadcrumbs">
				<a href="#">Home</a>
				<span>&gt;</span>
				<span>My Profile</span>
			</nav>
			<div class="row-fluid">
				<span class="span12 title">My Profile</span>
				<nav class="profile-links">
					<a href="#">Edit Profile</a>
					<span class="divider">|</span>
					<a href="#">My Messages</a>
				</nav>
			</div>
			<div class="row-fluid">
				<hr class="span12 stripeHr">
			</div>
			<script type="text/javascript">
				CQ.WCM.edit({"path":"/content/geometrixx-media/en/community/jcr:content/category-title","type":"geometrixx-media/components/category-title","csp":"community|page/category-title"});
			</script>
		</div>
	</div>

	<cq:include path="superParsys" resourceType="foundation/components/parsys"/>
	<cq:include path="start" resourceType="foundation/components/form/start"/>
	<div class="row-fluid">
		<div class="span4">
			<div class="parsys grid-4-par">
				<div class="section-title clearfix">
					<p>user profile</p>
				</div>
			</div>

			<div class="parsys grid-4-par">
				<div class="user-detail clearfix">
					<div class="user-detail-left span6">
						<cq:include path="right-par/image" resourceType="geometrixx-media/components/image"/>
					</div>
					<div class="user-detail-right span6">
                                            <cq:include path="user-badge" resourceType="/apps/geometrixx-media/components/badgelist" />
						<ul>
							<li>
								<p>Joined</p>
								<span>17 Oct 2011</span>
							</li>
							<li>
								<p>Joined</p>
								<span>17 Oct 2011</span>
							</li>
							<li>
								<p>Joined</p>
								<span>17 Oct 2011</span>
							</li>
							<li>
								<p>Joined</p>
								<span>17 Oct 2011</span>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<%
				if (currentNode.hasNode("./social/relationships/following")) {
					Node socialNode = currentNode.getNode("./social/relationships/following");

				}
			%>
			<cq:include path="peopleboxlist" resourceType="geometrixx-media/components/peopleboxlist"/>
			<div class="parsys grid-4-par">
			</div>
		</div>
		<div class="span8">
			<div class="parsys grid-8-par">
				<div class="personal-info section">
					<div class="personal-info">

						<div class="section-title clearfix">
							<p>edit information</p>
							<a href="./public#">my public profile &gt;</a>
						</div>

						<div class="personal-info-detail">

							<div class="form-section">
								<h4>Personal Information</h4>
								<div class="row-fluid">
									<div class="span6">
										<div class="row-fluid">
											<div class="text section">
												<div class="form_row">
													<cq:include path="left-par/text" resourceType="foundation/components/form/text"/>
													<!--<div class="form_leftcol">
														<div class="form_leftcollabel">
															<label for="profile_displayName">Display name</label>
														</div>
														<div class="form_leftcolmark">
															&nbsp;
														</div>
													</div>
													<div class="form_rightcol" id="displayName_rightcol">
														<div id="displayName_0_wrapper" class="form_rightcol_wrapper">
															<input class="form_field form_field_text" id="profile_displayName" name="displayName" value="" size="35" onkeydown="">
														</div>
													</div>-->
												</div>
												<div class="form_row_description"></div>
											</div>
											<div class="text section">
												<div class="form_row">
													<cq:include path="left-par/text_0" resourceType="foundation/components/form/text"/>
													<!--<div class="form_leftcol">
														<div class="form_leftcollabel">
															<label for="profile_firstName">First name</label>
														</div>
														<div class="form_leftcolmark">
															&nbsp;
														</div>
													</div>
													<div class="form_rightcol" id="firstName_rightcol">
														<div id="firstName_0_wrapper" class="form_rightcol_wrapper">
															<input class="form_field form_field_text" id="profile_firstName" name="firstName" value="" size="35" onkeydown="">
														</div>
													</div>-->
												</div>
												<div class="form_row_description"></div>
											</div>
											<div class="text section">
												<div class="form_row">
													<cq:include path="left-par/text_2" resourceType="foundation/components/form/text"/>
													<!--<div class="form_leftcol">
														<div class="form_leftcollabel">
															<label for="profile_lastName">Last name</label>
														</div>
														<div class="form_leftcolmark">
															&nbsp;
														</div>
													</div>
													<div class="form_rightcol" id="lastName_rightcol">
														<div id="lastName_0_wrapper" class="form_rightcol_wrapper">
															<input class="form_field form_field_text" id="profile_lastName" name="lastName" value="" size="35" onkeydown="">
														</div>
													</div>-->
												</div>
												<div class="form_row_description"></div>
											</div>
										</div>
									</div>
									<div class="span6">
										<div class="row-fluid">
											<div class="text section">
												<div class="form_row">
													<cq:include path="left-par/text_3" resourceType="foundation/components/form/text"/>
													<!--<div class="form_leftcol">
														<div class="form_leftcollabel">
															<label for="profile_email">E-mail</label>
														</div>
														<div class="form_leftcolmark">
															&nbsp;
														</div>
													</div>
													<div class="form_rightcol" id="email_rightcol">
														<div id="email_0_wrapper" class="form_rightcol_wrapper">
															<input class="form_field form_field_text form_field_multivalued" id="profile_email" name="email" value="" size="35" onkeydown="">
														</div>
													</div>-->
												</div>
												<div class="form_row_description"></div>
											</div>

											<div class="hidden">
												<cq:include path="left-par/text_4" resourceType="foundation/components/form/text"/>
											</div>

											<div class="row-fluid">
												<div class="span6">
													<div class="dropdown section">
														<div class="form_row">
															<cq:include path="left-par/dropdown" resourceType="foundation/components/form/dropdown"/>
															<!--<div class="form_leftcol">
																<div class="form_leftcollabel">
																	<label for="profile_gender">Gender</label>
																</div>
																<div class="form_leftcolmark">
																	&nbsp;
																</div>
															</div>
															<div class="form_rightcol">
																<select class="form_field form_field_select" id="profile_gender" name="gender">
																	<option value="Female">
																		Female
																	</option>
																	<option value="Male">
																		Male
																	</option>
																</select>
															</div>-->
														</div>
														<div class="form_row_description"></div>
													</div>
												</div>
												<div class="span6">
													<div class="text section">
														<div class="form_row">
															<div class="form_leftcol">
																<div class="form_leftcollabel">
																	<label for="profile_birthdate">Birthdate</label>
																</div>
																<div class="form_leftcolmark">
																	&nbsp;
																</div>
															</div>
															<div class="form_rightcol" id="birthdate_rightcol">
																<div id="birthdate_0_wrapper" class="form_rightcol_wrapper">
																	<input class="form_field form_field_text" id="profile_birthdate" name="birthdate" value="" size="35" onkeydown="">
																</div>
															</div>
														</div>
														<div class="form_row_description"></div>
													</div>

												</div>
											</div>
											<div class="row-fluid">
												<div class="span9">
													<div class="text section">
														<div class="form_row">
															<div class="form_leftcol">
																<div class="form_leftcollabel">
																	<label for="profile_city">City</label>
																</div>
																<div class="form_leftcolmark">
																	&nbsp;
																</div>
															</div>
															<div class="form_rightcol" id="city_rightcol">
																<div id="city_0_wrapper" class="form_rightcol_wrapper">
																	<input class="form_field form_field_text" id="profile_city" name="city" value="" size="35" onkeydown="">
																</div>
															</div>
														</div>
														<div class="form_row_description"></div>
													</div>
												</div>
												<div class="span3">
													<div class="dropdown section">
														<div class="form_row">
															<div class="form_leftcol">
																<div class="form_leftcollabel">
																	<label for="profile_state">State</label>
																</div>
																<div class="form_leftcolmark">
																	&nbsp;
																</div>
															</div>
															<div class="form_rightcol">
																<select class="form_field form_field_select" id="profile_stater" name="state">
																	<option value="Female">
																		Option 1
																	</option>
																	<option value="Male">
																		Option 2
																	</option>
																</select>
															</div>
														</div>
														<div class="form_row_description"></div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>

							<div class="form-section">
								<h4>Personal Information</h4>
								<div class="row-fluid">
									<div class="span12">
										<div class="text section">
											<div class="form_row">
												<cq:include path="right-par/text_5" resourceType="foundation/components/form/text"/>
												<!--
												<div class="form_leftcol">
													<div class="form_leftcollabel">
														<label for="profile_aboutMe">About me</label>
													</div>
													<div class="form_leftcolmark">
														&nbsp;
													</div>
												</div>
												<div class="form_rightcol" id="aboutMe_rightcol">
													<div id="aboutMe_0_wrapper" class="form_rightcol_wrapper">
														<textarea class="form_field form_field_textarea" id="profile_aboutMe" name="aboutMe" rows="3" cols="35" onkeydown=""></textarea>
													</div>
												</div>
												-->
											</div>
											<div class="form_row_description"></div>
										</div>
									</div>
								</div>
								<div class="row-fluid">
									<div class="span12">
										<div class="text section">
											<div class="form_row">
												<cq:include path="right-par/text_7" resourceType="foundation/components/form/text"/>
												<!--<div class="form_leftcol">
													<div class="form_leftcollabel">
														<label for="profile_hobbies">Hobbies</label>
													</div>
													<div class="form_leftcolmark">
														&nbsp;
													</div>
												</div>
												<div class="form_rightcol" id="hobbies_rightcol">
													<div id="hobbies_0_wrapper" class="form_rightcol_wrapper">
														<cq:include path="right-par/text_7" resourceType="foundation/components/form/text"/>
														<textarea class="form_field form_field_textarea" id="profile_hobbies" name="hobbies" rows="3" cols="35" onkeydown=""></textarea>
													</div>
												</div>-->
											</div>
											<div class="form_row_description"></div>
										</div>
									</div>
								</div>
							</div>
							<cq:include path="end" resourceType="foundation/components/form/end"/>
						</div>
					</div>
					<script type="text/javascript">
						$CQ(function(){
							CQ.soco.commons.attachToPagination($CQ("#pagination"), $CQ(".topics>ul"), 0, 25, "/content/geometrixx-media/en/community/jcr:content/grid-8-par/forum");
						});
					</script>
					<%if (isAuthorMode) {%>
						<script type="text/javascript">
							CQ.WCM.edit({"path":"/content/geometrixx-media/en/community/jcr:content/grid-8-par/forum","dialog":"/libs/social/forum/components/forum/dialog","type":"geometrixx-media/components/social/forum/components/forum","csp":"community|page/grid-8-par|parsys/forum","isContainer":true,"editConfig":{"listeners":{"afterinsert":"REFRESH_PAGE","afteredit":"REFRESH_PAGE"},"actions":[CQ.wcm.EditBase.EDIT,CQ.wcm.EditBase.COPYMOVE,CQ.wcm.EditBase.DELETE,CQ.wcm.EditBase.INSERT,{"xtype":"tbseparator","jcr:primaryType":"nt:unstructured"},{"handler":"function(){CQ.soco.commons.openModeration();}","jcr:primaryType":"nt:unstructured","text":"Manage comments"}]}});
						</script>
					<%}%>
				</div>
				<div class="new section">
					<%if (isAuthorMode) {%>
						<script type="text/javascript">
							CQ.WCM.edit({"path":"/content/geometrixx-media/en/community/jcr:content/grid-8-par/*","type":"foundation/components/parsys/new","csp":"community|page/grid-8-par|parsys/new","editConfig":{"actions":[CQ.wcm.EditBase.INSERT],"disableTargeting":true}});
						</script>
					<%}%>
				</div>
				<%if (isAuthorMode) {%>
					<script type="text/javascript">
						CQ.WCM.edit({"path":"/content/geometrixx-media/en/community/jcr:content/grid-8-par","type":"foundation/components/parsys","csp":"community|page/grid-8-par|parsys","isContainer":true});
					</script>
				<%}%>
			</div>
		</div>
	</div>

</div>
<script type="text/javascript">
	$(document).ready(function() {
		$('.form_mv_add').hide();
	});
</script>