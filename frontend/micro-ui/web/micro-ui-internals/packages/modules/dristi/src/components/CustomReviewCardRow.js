import React from "react";
import { FlagIcon } from "../icons/svgIndex";
import DocViewerWrapper from "../pages/employee/docViewerWrapper";
import { EditPencilIcon } from "@egovernments/digit-ui-react-components";

const CustomReviewCardRow = ({ isScrutiny, data, handleOpenPopup, titleIndex, dataIndex, name, configKey, dataError, t, config, titleHeading }) => {
  const { type = null, label = null, value = null, badgeType = null } = config;
  const tenantId = window?.Digit.ULBService.getCurrentTenantId();
  const extractValue = (data, key) => {
    if (!key.includes(".")) {
      return data[key];
    }
    const keyParts = key.split(".");
    let value = data;
    keyParts.forEach((part) => {
      if (value && value.hasOwnProperty(part)) {
        value = value[part];
      } else {
        value = undefined;
      }
    });
    return value;
  };

  switch (type) {
    case "title":
      let title = "";
      if (Array.isArray(value)) {
        title = value.map((key) => extractValue(data, key)).join(" ");
      } else {
        title = extractValue(data, value);
      }
      return (
        <div className={`title-main ${isScrutiny && dataError && "error"}`}>
          <div className={`title ${isScrutiny && (dataError ? "column" : "")}`}>
            <div>{`${titleIndex}. ${titleHeading == true ? t("CS_CHEQUE_NO") + " " : ""}${title}`}</div>
            {badgeType && <div>{extractValue(data, badgeType)}</div>}

            {isScrutiny && (
              <div
                className="flag"
                onClick={(e) => {
                  handleOpenPopup(e, configKey, name, dataIndex, Array.isArray(value) ? type : value);
                }}
                key={dataIndex}
              >
                {/* {badgeType && <div>{extractValue(data, badgeType)}</div>} */}
                {dataError ? <EditPencilIcon /> : <FlagIcon />}
              </div>
            )}
          </div>
          {dataError && isScrutiny && (
            <div className="scrutiny-error input">
              <FlagIcon isError={true} />
              {dataError}
            </div>
          )}
        </div>
      );
    case "text":
      const textValue = extractValue(data, value);
      return (
        <div className={`text-main ${isScrutiny && dataError && "error"}`}>
          <div className="text">
            <div className="label">{t(label)}</div>
            <div className="value">
              {Array.isArray(textValue) && textValue.map((text) => <div> {text} </div>)}
              {!Array.isArray(textValue) && textValue}
            </div>
            {isScrutiny && (
              <div
                className="flag"
                onClick={(e) => {
                  handleOpenPopup(e, configKey, name, dataIndex, value);
                }}
                key={dataIndex}
              >
                {dataError && isScrutiny ? <EditPencilIcon /> : <FlagIcon />}
              </div>
            )}
          </div>
          {dataError && isScrutiny && (
            <div className="scrutiny-error input">
              <FlagIcon isError={true} />
              {dataError}
            </div>
          )}
        </div>
      );

    case "amount":
      return (
        <div className={`amount-main ${isScrutiny && dataError && "error"}`}>
          <div className="amount">
            <div className="label">{t(label)}</div>
            <div className="value"> {`₹${extractValue(data, value)}`} </div>
            {isScrutiny && (
              <div
                className="flag"
                onClick={(e) => {
                  handleOpenPopup(e, configKey, name, dataIndex, value);
                }}
                key={dataIndex}
              >
                {dataError && isScrutiny ? <EditPencilIcon /> : <FlagIcon />}
              </div>
            )}
          </div>
          {dataError && isScrutiny && (
            <div className="scrutiny-error input">
              <FlagIcon isError={true} />
              {dataError}
            </div>
          )}
        </div>
      );
    case "phonenumber":
      const numbers = extractValue(data, value);
      return (
        <div className={`phone-number-main ${isScrutiny && dataError && "error"}`}>
          <div className="phone-number">
            <div className="label">{t(label)}</div>
            <div className="value">
              {Array.isArray(numbers) && numbers.map((number) => <div> {`+91-${number}`} </div>)}
              {!Array.isArray(numbers) && `+91-${numbers}`}
            </div>
            {isScrutiny && (
              <div
                className="flag"
                onClick={(e) => {
                  handleOpenPopup(e, configKey, name, dataIndex, value);
                }}
                key={dataIndex}
              >
                {dataError && isScrutiny ? <EditPencilIcon /> : <FlagIcon />}
              </div>
            )}
          </div>
          {dataError && isScrutiny && (
            <div className="scrutiny-error input">
              <FlagIcon isError={true} />
              {dataError}
            </div>
          )}
        </div>
      );
    case "image":
      return (
        <div className={`image-main ${isScrutiny && dataError && "error"}`}>
          <div className={`image ${!isScrutiny ? "column" : ""}`}>
            <div className="label">{t(label)}</div>
            <div className={`value ${!isScrutiny ? "column" : ""}`} style={{ overflowX: "scroll" }}>
              {Array.isArray(value)
                ? value?.map((value) =>
                    extractValue(data, value) && Array.isArray(extractValue(data, value)) ? (
                      extractValue(data, value)?.map((data, index) => {
                        if (data?.fileStore) {
                          return (
                            <DocViewerWrapper
                              key={`${value}-${index}`}
                              fileStoreId={data?.fileStore}
                              displayFilename={data?.fileName}
                              tenantId={tenantId}
                              docWidth="250px"
                            />
                          );
                        } else if (data?.document) {
                          return data?.document?.map((data, index) => {
                            return (
                              <DocViewerWrapper
                                key={`${value}-${index}`}
                                fileStoreId={data?.fileStore}
                                displayFilename={data?.fileName}
                                tenantId={tenantId}
                                docWidth="250px"
                              />
                            );
                          });
                        } else {
                          return null;
                        }
                      })
                    ) : extractValue(data, value) ? (
                      <DocViewerWrapper
                        key={`${value}-${extractValue(data, value)?.name}`}
                        fileStoreId={extractValue(data, value)?.fileStore}
                        displayFilename={extractValue(data, value)?.fileName}
                        tenantId={tenantId}
                        docWidth="250px"
                      />
                    ) : null
                  )
                : null}
            </div>
            <div
              className="flag"
              onClick={(e) => {
                handleOpenPopup(e, configKey, name, dataIndex, value);
              }}
              key={dataIndex}
            >
              {isScrutiny && (dataError ? <EditPencilIcon /> : <FlagIcon />)}
            </div>
          </div>
          {dataError && isScrutiny && (
            <div className="scrutiny-error input">
              <FlagIcon isError={true} />
              {dataError}
            </div>
          )}
        </div>
      );
    case "address":
      const addressDetails = extractValue(data, value);
      let address = [""];
      if (Array.isArray(addressDetails)) {
        address = addressDetails.map(({ addressDetails }) => {
          return `${addressDetails?.locality}, ${addressDetails?.city}, ${addressDetails?.district}, ${addressDetails?.state} - ${addressDetails?.pincode}`;
        });
      } else {
        address = [
          `${addressDetails?.locality}, ${addressDetails?.city}, ${addressDetails?.district}, ${addressDetails?.state} - ${addressDetails?.pincode}`,
        ];
      }

      return (
        <div className={`address-main ${isScrutiny && dataError && "error"}`}>
          <div className="address">
            <div className="label">{t(label)}</div>
            <div className={`value ${!isScrutiny ? "column" : ""}`}>
              {address.map((item) => (
                <p>{item}</p>
              ))}
            </div>

            {isScrutiny && (
              <div
                className="flag"
                onClick={(e) => {
                  handleOpenPopup(e, configKey, name, dataIndex, value);
                }}
                key={dataIndex}
              >
                {dataError && isScrutiny ? <EditPencilIcon /> : <FlagIcon />}
              </div>
            )}
          </div>
          {dataError && isScrutiny && (
            <div className="scrutiny-error input">
              <FlagIcon isError={true} />
              {dataError}
            </div>
          )}
        </div>
      );
    default:
      const defaulValue = extractValue(data, value);
      return (
        <div>
          <div className="text">
            <div className="label">{t(label)}</div>
            <div className="value">
              {Array.isArray(defaulValue) && defaulValue.map((text) => <div> {text} </div>)}
              {!Array.isArray(defaulValue) && defaulValue}
            </div>
            {isScrutiny && (
              <div
                className="flag"
                onClick={(e) => {
                  handleOpenPopup(e, configKey, name, dataIndex, value);
                }}
                key={dataIndex}
              >
                {dataError && isScrutiny ? <EditPencilIcon /> : <FlagIcon />}
              </div>
            )}
          </div>
          <div className="scrutiny-error input">
            <FlagIcon isError={true} />
            {dataError}
          </div>
        </div>
      );
  }
};

export default CustomReviewCardRow;